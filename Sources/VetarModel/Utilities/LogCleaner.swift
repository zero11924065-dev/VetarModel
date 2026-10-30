//
//  LogCleaner.swift
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

/// 只清理已知日志文件，不删除目录或其他文件。
public enum LogCleaner {

    /// 已知日志文件名白名单
    public static let knownLogNames = ["vetar_bridge_stderr.log", "vetar-perf.log"]

    /// 删除已知日志文件，返回释放的字节数。文件不存在/删不掉静默跳过（日志本就是易失物）。
    @discardableResult
    public static func cleanKnownLogs(
        directory: URL = URL(fileURLWithPath: NSTemporaryDirectory())
    ) -> Int64 {
        var freed: Int64 = 0
        for name in knownLogNames {
            let url = directory.appendingPathComponent(name)
            let values = try? url.resourceValues(forKeys: [.fileSizeKey, .isRegularFileKey])
            guard values?.isRegularFile == true else { continue }
            freed += Int64(values?.fileSize ?? 0)
            try? FileManager.default.removeItem(at: url)
        }
        return freed
    }
}
