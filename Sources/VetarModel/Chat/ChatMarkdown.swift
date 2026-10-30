//
//  ChatMarkdown.swift
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

/// 会话文本的轻量 Markdown 渲染。
/// 使用 AttributedString 标准解析；无法完整解析时保留可解析内容或回退纯文本。
public enum ChatMarkdown {

    /// 渲染助手消息文本为带样式的 AttributedString（仅排版，不改字）
    public static func render(_ text: String) -> AttributedString {
        if let parsed = try? AttributedString(
            markdown: text,
            options: AttributedString.MarkdownParsingOptions(
                interpretedSyntax: .full,
                failurePolicy: .returnPartiallyParsedIfPossible)
        ) {
            return parsed
        }
        return AttributedString(text)
    }

    /// 渲染 + 流式光标（光标不带样式）
    public static func renderStreaming(_ text: String) -> AttributedString {
        var rendered = render(text)
        rendered.append(AttributedString("▍"))
        return rendered
    }
}
