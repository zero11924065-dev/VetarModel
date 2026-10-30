//
//  KBActionBarAvailability.swift
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

/// 知识库操作栏「加入训练 / 再次学习 / 移出队列」的适用性判定。
/// 输入为选中条目的最小状态摘要，输出为按钮可用性与不可用原因。
enum KBActionBarAvailability {

    /// 判定所需的最小条目摘要
    struct Summary: Equatable, Sendable {
        let usedInTraining: Bool
        let inTrainingQueue: Bool
    }

    enum Action {
        /// 加入训练（未学过且不在队列的条目才适用）
        case enqueue
        /// 再次学习（已学过且不在队列的条目才适用）
        case requeue
        /// 移出队列（在队列中的条目才适用）
        case dequeue
    }

    /// 按钮是否可用：未选中恒不可用（旧行为一个比特不变）
    static func isEnabled(_ action: Action, selection: [Summary]) -> Bool {
        switch action {
        case .enqueue:
            return selection.contains { !$0.usedInTraining && !$0.inTrainingQueue }
        case .requeue:
            return selection.contains { $0.usedInTraining && !$0.inTrainingQueue }
        case .dequeue:
            return selection.contains { $0.inTrainingQueue }
        }
    }

    /// 不可用时的悬停原因；可用或未选中返回 nil（未选中保持旧行为：不给额外提示）。
    /// 混合选区（部分在队列、部分不满足学习状态）给如实的中性文案。
    static func disabledReason(_ action: Action, selection: [Summary]) -> String? {
        guard !selection.isEmpty, !isEnabled(action, selection: selection) else { return nil }
        let allQueued = selection.allSatisfy(\.inTrainingQueue)
        let anyQueued = selection.contains(where: \.inTrainingQueue)
        switch action {
        case .enqueue:
            if allQueued { return "选中的内容已在训练队列中" }
            if anyQueued { return "选中的内容都已学过或已在队列中" }
            return "选中的内容都已学过，请用「再次学习」"
        case .requeue:
            if allQueued { return "选中的内容已在训练队列中" }
            if anyQueued { return "选中的内容还没学过或已在队列中" }
            return "选中的内容还没学过，请用「加入训练」"
        case .dequeue:
            return "选中的内容不在训练队列中"
        }
    }
}
