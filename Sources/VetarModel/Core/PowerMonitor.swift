//
//  PowerMonitor.swift
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
#if canImport(IOKit)
import IOKit.ps
#endif

/// 电源状态监控：查询当前供电状态并接收变化回调。
/// 生产实现走 IOPS（IOKit Power Sources）；测试喂假实现。
public protocol PowerMonitoring: AnyObject, Sendable {
    /// 当前是否接电源供电（AC/UPS 算接电源；电池算未接；探测失败按接电源处理，
    /// 宁可训也不错杀——桌面 Mac 无电池传感器，恒 true）
    var isOnACPower: Bool { get }
    /// 电源来源变化回调（在主 RunLoop 触发；参数 = 变化后的 isOnACPower）
    var onChange: (@Sendable (Bool) -> Void)? { get set }
}

/// 电源来源类型的纯函数判定（测试钉死口径；日志不出现实现细节）
public enum PowerSourceClassifier {
    /// IOPS 提供的来源类型字符串 → 是否视为「接电源」。
    /// "AC Power" / "UPS Power" = 接电源；"Battery Power" = 电池；未知值按接电源（宁训不错杀）。
    public static func isACPowered(providingSourceType: String) -> Bool {
        switch providingSourceType {
        case "Battery Power": return false
        default: return true // "AC Power" / "UPS Power" / 未知
        }
    }
}

/// 生产电源监控：IOPSNotificationCreateRunLoopSource 监听电源来源变化。
/// 桌面 Mac（无电池）IOPSGetProvidingPowerSourceType 恒返回 AC Power，天然通过闸。
public final class IOPSPowerMonitor: PowerMonitoring, @unchecked Sendable {

    private let lock = NSLock()
    nonisolated(unsafe) private var runLoopSource: CFRunLoopSource?
    private var _onChange: (@Sendable (Bool) -> Void)?

    public init() {
        #if canImport(IOKit)
        let context = Unmanaged.passUnretained(self).toOpaque()
        runLoopSource = IOPSNotificationCreateRunLoopSource({ context in
            guard let context else { return }
            let monitor = Unmanaged<IOPSPowerMonitor>.fromOpaque(context).takeUnretainedValue()
            monitor.notifyChange()
        }, context)?.takeUnretainedValue()
        if let runLoopSource {
            CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, CFRunLoopMode.commonModes)
        }
        #endif
    }

    deinit {
        if let runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetMain(), runLoopSource, CFRunLoopMode.commonModes)
            CFRunLoopSourceInvalidate(runLoopSource)
        }
    }

    public var onChange: (@Sendable (Bool) -> Void)? {
        get { lock.withLock { _onChange } }
        set { lock.withLock { _onChange = newValue } }
    }

    public var isOnACPower: Bool {
        #if canImport(IOKit)
        guard let info = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let type = IOPSGetProvidingPowerSourceType(info)?.takeUnretainedValue() as String?
        else { return true } // 探测失败按接电源（桌面 Mac 走这里）
        return PowerSourceClassifier.isACPowered(providingSourceType: type)
        #else
        return true
        #endif
    }

    private func notifyChange() {
        let isAC = isOnACPower
        let callback = lock.withLock { _onChange }
        callback?(isAC)
    }
}

/// 测试用假电源：状态随时可拨，拨动即触发 onChange（同生产语义）。
public final class FakePowerMonitor: PowerMonitoring, @unchecked Sendable {
    private let lock = NSLock()
    private var _isOnAC: Bool
    private var _onChange: (@Sendable (Bool) -> Void)?

    public init(isOnACPower: Bool = true) {
        self._isOnAC = isOnACPower
    }

    public var isOnACPower: Bool {
        lock.withLock { _isOnAC }
    }

    public var onChange: (@Sendable (Bool) -> Void)? {
        get { lock.withLock { _onChange } }
        set { lock.withLock { _onChange = newValue } }
    }

    /// 测试拨动电源状态（值变化时触发 onChange）
    public func setOnACPower(_ value: Bool) {
        let changed = lock.withLock { () -> Bool in
            let changed = _isOnAC != value
            _isOnAC = value
            return changed
        }
        if changed {
            let callback = lock.withLock { _onChange }
            callback?(value)
        }
    }
}
