//
//  TrainingParamStepperDebouncer.swift
//  VetarModel
//
//  Copyright (C) 2026 Vetar
//
//  This file is part of VetarModel.
//  This file is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This file is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with VetarModel. If not, see <https://www.gnu.org/licenses/>.
//

import Foundation

/// 通用整数步进器防抖器。
/// 连续 tick 合并为一次持久化回调；支持取消与立即 flush。
/// 调度器由调用方注入，便于使用主队列或确定性测试调度器。
/// 线程约定：主线程专用（步进器回调与落盘都在主线程；本类无内部锁）。
/// @unchecked Sendable 仅为满足 DispatchWorkItem 的 @Sendable 闭包约束——
/// 调度器契约保证回调在主队列执行，内部状态事实上只在主线程被触碰。
public final class TrainingParamStepperDebouncer: @unchecked Sendable {

    /// 调度一个回调在 delay 秒后执行；返回的闭包用于取消（取消已执行的任务是无害空操作）
    public typealias Scheduler =
        @Sendable (_ delay: TimeInterval, _ action: @escaping @Sendable () -> Void) -> () -> Void

    /// 默认防抖窗口
    public static let defaultDelay: TimeInterval = 0.4

    /// 生产调度器：主队列延迟执行，取消即作废
    public static let mainQueueScheduler: Scheduler = { delay, action in
        let item = DispatchWorkItem(block: action)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: item)
        return { item.cancel() }
    }

    private let delay: TimeInterval
    private let scheduler: Scheduler
    /// 持久化动作，由调用方注入
    private let persist: (Int) -> Void

    /// 待落盘的最新值（nil = 无待写）
    private var pendingValue: Int?
    /// 任务序号：每次 tick/flush/cancel +1，已排队的旧回调比对序号失效即丢弃——
    /// 使已经排队但过期的回调失效。
    private var generation = 0
    private var cancelScheduled: (() -> Void)?

    public init(
        delay: TimeInterval = TrainingParamStepperDebouncer.defaultDelay,
        scheduler: @escaping Scheduler,
        persist: @escaping (Int) -> Void
    ) {
        self.delay = delay
        self.scheduler = scheduler
        self.persist = persist
    }

    /// 一次步进 tick：记录最新值并重排落盘计时——多次 tick 合并为一次落盘，
    /// 落盘值取最后一次点击（中间值只活在视图层本地显示，不落盘）
    public func tick(_ value: Int) {
        pendingValue = value
        generation += 1
        let expected = generation
        cancelScheduled?()
        cancelScheduled = scheduler(delay) { [weak self] in
            guard let self, self.generation == expected else { return }
            self.persistPending()
        }
    }

    /// 立即落盘待写值（消费入口执行前 / 视图消失前 / 模型切换前调用）；无待写值时空操作
    public func flush() {
        generation += 1 // 已排队的回调全部失效，不会重复落盘
        cancelScheduled?()
        cancelScheduled = nil
        persistPending()
    }

    /// 丢弃待写值（文本框草稿提交等互斥路径调用：文本值为准，步进残留不落盘）
    public func cancel() {
        pendingValue = nil
        generation += 1
        cancelScheduled?()
        cancelScheduled = nil
    }

    /// 是否还有待落盘值（测试断言用）
    public var hasPendingValue: Bool { pendingValue != nil }

    private func persistPending() {
        guard let value = pendingValue else { return }
        pendingValue = nil
        cancelScheduled = nil
        persist(value)
    }
}
