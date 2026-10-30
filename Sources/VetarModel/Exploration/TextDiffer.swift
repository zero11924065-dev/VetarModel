//
//  TextDiffer.swift
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

/// 一次文本对比产生的「修改前 → 修改后」片段。
/// 纯新增时 before 为空串，纯删除时 after 为空串。
public struct DiffFragment: Codable, Equatable, Sendable {
    /// 修改前片段（纯新增时为空串）
    public let before: String
    /// 修改后片段（纯删除时为空串）
    public let after: String
    /// 碎片生成时间（由调用方注入，测试可控）
    public let createdAt: Date

    public init(before: String, after: String, createdAt: Date) {
        self.before = before
        self.after = after
        self.createdAt = createdAt
    }
}

/// 段落级文本对比引擎。
///
/// 口径（逐项写死，测试钉死）：
/// - 对比粒度：按换行分段（段落级），不做逐字 diff——训练要的是「哪段被改成了什么」；
/// - 变更率 changeRatio = 变更字符数（各碎片 before+after 字数之和，截断前口径）
///   / max(旧正文字数, 1)；
/// - 小改动判定：`changeRatio < 0.2 且碎片非空` → 标记为 `isMinorChange`；
/// - 容量保护：单段碎片 before/after 各截断到 2000 字符。
public enum TextDiffer {

    /// 小改动变更率阈值（低于此值且碎片非空 → 产碎片）
    public static let smallChangeMaxRatio = 0.2
    /// 单条目碎片容量上限（超出丢最旧；store 侧执行）
    public static let maxFragmentsPerEntry = 50
    /// 单段碎片 before/after 各自的字符上限
    public static let maxFragmentChars = 2_000

    /// 对比结果
    public struct DiffResult: Equatable, Sendable {
        /// 纠错碎片（无变化时为空）
        public var fragments: [DiffFragment]
        /// 变更率（变更字符数 / max(旧字数, 1)，截断前口径）
        public var changeRatio: Double
        /// 是否小改动（产碎片）：变更率低于阈值且确有变化
        public var isMinorChange: Bool {
            changeRatio < TextDiffer.smallChangeMaxRatio && !fragments.isEmpty
        }

        public init(fragments: [DiffFragment], changeRatio: Double) {
            self.fragments = fragments
            self.changeRatio = changeRatio
        }
    }

    /// 段落级对比：提取「修改前片段 → 修改后片段」对。
    /// - Parameter createdAt: 碎片时间戳（调用方注入，测试可断言）。
    public static func diff(old: String, new: String, createdAt: Date) -> DiffResult {
        guard old != new else { return DiffResult(fragments: [], changeRatio: 0) }

        let oldLines = old.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        let newLines = new.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)

        // Swift 标准库 Myers diff： removals 的 offset 基于旧数组，insertions 基于新数组；
        // 未出现在差分里的行是两版共有且顺序一致（对齐基准）。
        let difference = newLines.difference(from: oldLines)
        var removedOffsets = Set<Int>()
        var insertedOffsets = Set<Int>()
        for change in difference {
            switch change {
            case .remove(let offset, _, _): removedOffsets.insert(offset)
            case .insert(let offset, _, _): insertedOffsets.insert(offset)
            }
        }

        // 双指针走查：连续的删除/插入聚成一块碎片，遇到未变行即切断
        var blocks: [(before: String, after: String)] = []
        var beforeLines: [String] = []
        var afterLines: [String] = []
        func flush() {
            guard !beforeLines.isEmpty || !afterLines.isEmpty else { return }
            blocks.append((beforeLines.joined(separator: "\n"), afterLines.joined(separator: "\n")))
            beforeLines = []
            afterLines = []
        }
        var i = 0
        var j = 0
        while i < oldLines.count || j < newLines.count {
            if i < oldLines.count, removedOffsets.contains(i) {
                beforeLines.append(oldLines[i])
                i += 1
            } else if j < newLines.count, insertedOffsets.contains(j) {
                afterLines.append(newLines[j])
                j += 1
            } else {
                flush()
                i += 1
                j += 1
            }
        }
        flush()

        // 变更率用截断前口径（否则超长段被截断会人为压低变更率）
        let changedChars = blocks.reduce(0) { $0 + $1.before.count + $1.after.count }
        let ratio = Double(changedChars) / Double(max(old.count, 1))

        let fragments = blocks.map {
            DiffFragment(
                before: String($0.before.prefix(maxFragmentChars)),
                after: String($0.after.prefix(maxFragmentChars)),
                createdAt: createdAt)
        }
        return DiffResult(fragments: fragments, changeRatio: ratio)
    }
}
