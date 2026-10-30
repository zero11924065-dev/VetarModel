//
//  StorageUsage.swift
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

/// 本地存储占用的分项统计与目录测量。
/// 支持用户模型、共享模型资源和 Ollama 模型三类计数；
/// Ollama 未运行时可用目录枚举作为回退。
public struct StorageUsage: Equatable, Sendable {
    /// 我的模型（字节）
    public var userModelsBytes: Int64
    /// 模型资源/底座（字节）
    public var baseModelsBytes: Int64
    /// 训练大模型（字节）
    public var ollamaModelsBytes: Int64
    /// 训练大模型数字是否与列表同源（true = Ollama API 口径；false = 磁盘枚举兜底）
    public var ollamaFromAPI: Bool

    public init(
        userModelsBytes: Int64,
        baseModelsBytes: Int64,
        ollamaModelsBytes: Int64,
        ollamaFromAPI: Bool
    ) {
        self.userModelsBytes = userModelsBytes
        self.baseModelsBytes = baseModelsBytes
        self.ollamaModelsBytes = ollamaModelsBytes
        self.ollamaFromAPI = ollamaFromAPI
    }

    /// 三项合计
    public var totalBytes: Int64 {
        userModelsBytes + baseModelsBytes + ollamaModelsBytes
    }

    /// 训练大模型默认磁盘目录（Ollama 未运行时的兜底统计口径）
    public static var defaultOllamaModelsDirectory: URL {
        FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".ollama/models", isDirectory: true)
    }

    /// 递归枚举目录求文件总大小（跳过隐藏文件；符号链接不重复计）
    public static func directorySize(at root: URL) -> Int64 {
        let fm = FileManager.default
        guard let enumerator = fm.enumerator(
            at: root, includingPropertiesForKeys: [.fileSizeKey, .isRegularFileKey],
            options: [.skipsHiddenFiles]) else { return 0 }
        var total: Int64 = 0
        for case let file as URL in enumerator {
            let values = try? file.resourceValues(forKeys: [.fileSizeKey, .isRegularFileKey])
            guard values?.isRegularFile == true else { continue }
            total += Int64(values?.fileSize ?? 0)
        }
        return total
    }

    /// 分项测量（后台线程调用）。
    /// - Parameter ollamaAPIBytes: Ollama 运行中时传已装模型 size 之和（与列表同源）；
    ///   传 nil（未运行）则枚举磁盘目录兜底。
    public static func measure(
        userModelsRoot: URL,
        baseModelsRoot: URL,
        ollamaModelsRoot: URL = defaultOllamaModelsDirectory,
        ollamaAPIBytes: Int64? = nil
    ) -> StorageUsage {
        let user = directorySize(at: userModelsRoot)
        let base = directorySize(at: baseModelsRoot)
        let (ollama, fromAPI): (Int64, Bool)
        if let apiBytes = ollamaAPIBytes {
            (ollama, fromAPI) = (apiBytes, true)
        } else {
            (ollama, fromAPI) = (directorySize(at: ollamaModelsRoot), false)
        }
        return StorageUsage(
            userModelsBytes: user,
            baseModelsBytes: base,
            ollamaModelsBytes: ollama,
            ollamaFromAPI: fromAPI
        )
    }

    /// 字节数格式化（与系统口径一致）
    public static func format(_ bytes: Int64) -> String {
        ByteCountFormatter.string(fromByteCount: bytes, countStyle: .file)
    }
}
