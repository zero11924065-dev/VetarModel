//
//  LogSanitizer.swift
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

public enum LogSanitizer {

    /// 顺序即优先级：先邮箱（避免被长串规则吃掉），再 Bearer，再 ≥32 长串，最后用户路径。
    private static let rules: [(pattern: String, template: String, options: NSRegularExpression.Options)] = [
        // 1. 邮箱
        (#"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}"#, "<邮箱>", []),
        // 2. Bearer <串>（大小写不敏感；串体取非空白贪婪，宁可多吞）
        (#"(?i)bearer[ \t]+\S+"#, "<令牌>", []),
        // 3. ≥32 位长串（token/密钥形态；字符集含 _ - . / +，不含 = 防吞 key=value 前缀）
        (#"[A-Za-z0-9_\-.+/]{32,}"#, "<令牌>", []),
        // 4. /Users/<名>（保留后续路径段；不含空白与斜杠的一段即用户名）
        (#"/Users/[^/\s]+"#, "/Users/<用户>", []),
    ]

    private static let regexes: [NSRegularExpression] = rules.map {
        // 字面量规则，初始化不会失败；失败即编译期可发现的编程错误
        // swiftlint:disable:next force_try
        try! NSRegularExpression(pattern: $0.pattern, options: $0.options)
    }

    /// 文本脱敏（四类规则按序全量替换）。
    public static func sanitize(_ text: String) -> String {
        var out = text
        for (idx, rule) in rules.enumerated() {
            let re = regexes[idx]
            let range = NSRange(out.startIndex..., in: out)
            out = re.stringByReplacingMatches(in: out, range: range,
                                              withTemplate: rule.template)
        }
        return out
    }

    /// 字节脱敏：UTF-8 直解，失败走有损解码（日志均为文本；先脱敏后截断，防切分漏扫）。
    public static func sanitize(_ data: Data) -> Data {
        let text = String(data: data, encoding: .utf8) ?? String(decoding: data, as: UTF8.self)
        return Data(sanitize(text).utf8)
    }
}
