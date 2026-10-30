//
//  ChatTextFilter.swift
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

/// 从聊天展示文本中移除 <think>…</think> 段。
///
/// 展示规则：
/// - 定稿内容（历史消息 / 生成完毕）：只剥「完整成对」的 <think>…</think>，
///   未闭合的 <think> 原样保留——防止把正文里正常出现的 `<think>` 字样之后的内容误删。
/// - 流式生成中途：临时把未闭合的尾部 <think> 段也藏掉（此时它大概率是还在输出的
///   思考过程）；生成一结束就回到上面的安全口径，被误藏的内容会自动恢复显示。
public enum ChatTextFilter {

    /// 安全口径：只移除完整成对的 <think>…</think> 段，结果做首尾空白裁剪。
    public static func stripThinkBlocks(_ text: String) -> String {
        strip(text, includeUnclosed: false)
    }

    /// 流式口径：完整成对段照删；末尾若有未闭合的 <think>，临时藏到文本末尾。
    /// 仅用于「正在生成」的气泡，绝不用于落盘或定稿展示。
    public static func stripThinkBlocksWhileStreaming(_ text: String) -> String {
        strip(text, includeUnclosed: true)
    }

    private static func strip(_ text: String, includeUnclosed: Bool) -> String {
        var result = text
        while let openRange = result.range(of: "<think>") {
            if let closeRange = result.range(of: "</think>", range: openRange.upperBound..<result.endIndex) {
                result.removeSubrange(openRange.lowerBound..<closeRange.upperBound)
            } else if includeUnclosed {
                result.removeSubrange(openRange.lowerBound..<result.endIndex)
            } else {
                // 安全口径：未闭合不删，且其后不可能再有成对块，直接结束
                break
            }
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
