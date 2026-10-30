//
//  BackgroundLearningLog.swift
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

/// 后台学习持久化运行日志（JSONL，每行 {"ts":ISO8601,"event":"..."}）。
/// 写失败静默不崩；文件超 2MB 时保留最新一半（简单截断重写）。
/// 内部串行队列，任何线程可调。
///
/// 调用方应只写入状态词、计数与标识，避免写入文档内容。
public final class BackgroundLearningLog: @unchecked Sendable {

    /// 单文件体积上限：超过即保留最新一半重写
    public static let maxFileBytes = 2 * 1024 * 1024

    /// JSONL 单行结构
    private struct Line: Codable {
        let ts: String
        let event: String
    }

    /// 串行写队列（追加写 + 截断重写在队列内原子完成）
    private let queue = DispatchQueue(label: "vetar.background-learning-log")
    private let fileURLStorage: URL
    private let timestamp: () -> String

    /// - Parameter directory: 由调用方注入的日志目录
    public init(directory: URL) {
        self.fileURLStorage = directory.appendingPathComponent("background-learning.log")
        let formatter = ISO8601DateFormatter()
        self.timestamp = { formatter.string(from: Date()) }
    }

    /// 日志文件位置（测试断言用）
    public var fileURL: URL { fileURLStorage }

    /// 追加一行事件（任何线程可调；写失败静默不崩）
    public func log(_ event: String) {
        queue.sync { appendLine(event) }
    }

    // MARK: - 内部（全部只在串行队列内执行）

    private func appendLine(_ event: String) {
        let line = Line(ts: timestamp(), event: event)
        let encoder = JSONEncoder()
        guard var data = try? encoder.encode(line) else { return }
        data.append(0x0A) // \n
        let fm = FileManager.default
        try? fm.createDirectory(
            at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        if let handle = try? FileHandle(forWritingTo: fileURL) {
            defer { try? handle.close() }
            _ = try? handle.seekToEnd()
            try? handle.write(contentsOf: data)
        } else {
            // 文件尚不存在：直接落盘
            try? data.write(to: fileURL)
        }
        truncateIfNeeded()
    }

    /// 超 2MB 保留最新一半：截断到首个换行边界（不保留半行残片），原子重写
    private func truncateIfNeeded() {
        let fm = FileManager.default
        guard let attrs = try? fm.attributesOfItem(atPath: fileURL.path),
              let size = attrs[.size] as? Int,
              size > Self.maxFileBytes,
              let data = try? Data(contentsOf: fileURL)
        else { return }
        var kept = data.suffix(Self.maxFileBytes / 2)
        if let newlineIndex = kept.firstIndex(of: 0x0A) {
            kept = kept.suffix(from: kept.index(after: newlineIndex))
        }
        try? Data(kept).write(to: fileURL, options: .atomic)
    }
}
