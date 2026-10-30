//
//  MTheme.swift
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
//  VetarModel 通用 SwiftUI 界面主题。
//

import SwiftUI

public enum MTheme {

    // MARK: - 中性背景
    public static let bgApp = adaptive(light: 0xFAFAF8, dark: 0x1E1E1C)
    public static let bgSidebar = adaptive(light: 0xF1F0EC, dark: 0x262624)
    public static let bgCard = adaptive(light: 0xFFFFFF, dark: 0x2C2C2A)
    public static let bgHover = adaptive(light: 0xEEEDE9, dark: 0x3A3A37)
    public static let bgActive = adaptive(light: 0xE5E3DE, dark: 0x444442)

    // MARK: - 边框
    public static let borderSubtle = adaptive(light: 0xECEAE5, dark: 0x3A3A37)
    public static let borderDefault = adaptive(light: 0xE2E0DA, dark: 0x444442)
    public static let borderStrong = adaptive(light: 0xD1CEC6, dark: 0x555552)

    // MARK: - 文字
    public static let textPrimary = adaptive(light: 0x1C1C1A, dark: 0xF2F1ED)
    public static let textSecondary = adaptive(light: 0x5C594F, dark: 0xB8B5AB)
    public static let textTertiary = adaptive(light: 0x8E8A80, dark: 0x8E8A80)
    public static let textDisabled = adaptive(light: 0xBDBAB0, dark: 0x5C594F)

    // MARK: - 主按钮
    public static let ink = adaptive(light: 0x1C1C1A, dark: 0xFAFAF8)
    public static let inkHover = adaptive(light: 0x37352F, dark: 0xFFFFFF)
    public static let onInk = adaptive(light: 0xFAFAF8, dark: 0x1C1C1A)

    // MARK: - 强调色
    public static let accent = Color(hex: 0x7C6BF5)
    public static let accentHover = Color(hex: 0x6857E8)
    public static let accentText = adaptive(light: 0x6857E8, dark: 0x8A7AF8)
    public static let accentBg = adaptive(light: 0xEBE9FC, dark: 0x2F2A55)
    public static let bgSelected = accentBg
    public static let accentBgSoft = adaptive(light: 0xF5F4FE, dark: 0x282442)
    public static let accentBorder = adaptive(light: 0xC9C2F8, dark: 0x443B80)
    public static let accentTextDeep = adaptive(light: 0x5546C8, dark: 0xA093FA)

    // MARK: - 语义色
    public static let ok = Color(hex: 0x3D9B63)
    public static let okBg = adaptive(light: 0xEBF6EF, dark: 0x24382C)
    public static let okBorder = adaptive(light: 0xC8E6D4, dark: 0x35563F)
    public static let okText = adaptive(light: 0x1F6B3E, dark: 0x7CCB9B)

    public static let warn = Color(hex: 0xC99A3F)
    public static let warnBg = adaptive(light: 0xFBF6E9, dark: 0x3A3222)
    public static let warnBorder = adaptive(light: 0xEEE2BE, dark: 0x54492C)
    public static let warnText = adaptive(light: 0x8A6D24, dark: 0xD9B868)

    public static let danger = Color(hex: 0xDC4C42)
    public static let dangerBg = adaptive(light: 0xFBEDEC, dark: 0x3E2825)
    public static let dangerBorder = adaptive(light: 0xF2C7C2, dark: 0x5E3833)
    public static let dangerText = adaptive(light: 0x963026, dark: 0xEB9188)

    // MARK: - 背景装饰
    public static let dotGrid = adaptive(light: 0xE2DFD6, dark: 0x3A3A37)

    // MARK: - 圆角
    public enum Radius {
        public static let s: CGFloat = 6
        public static let m2: CGFloat = 8
        public static let m: CGFloat = 10
        public static let l: CGFloat = 12
    }

    // MARK: - 字号
    public enum Typo {
        public static let display = Font.system(size: 28, weight: .semibold)
        public static let title2 = Font.system(size: 20, weight: .semibold)
        public static let pageTitle = Font.system(size: 16, weight: .semibold)
        public static let sectionTitle = Font.system(size: 14, weight: .semibold)
        public static let panelTitle = Font.system(size: 12, weight: .semibold)
        public static let body = Font.system(size: 13)
        public static let msgBody = Font.system(size: 14)
        public static let caption = Font.system(size: 12)
        public static let micro = Font.system(size: 11)
        public static let railLabel = Font.system(size: 10)
    }

    // MARK: - 阴影
    public enum Shadow {
        public static func card(dark: Bool = false) -> (color: Color, radius: CGFloat, y: CGFloat) {
            (Color.black.opacity(dark ? 0.028 : 0.055), 14, 5)
        }
        public static func popover(dark: Bool = false) -> (color: Color, radius: CGFloat, y: CGFloat) {
            (Color.black.opacity(dark ? 0.06 : 0.12), 30, 10)
        }
    }

    // MARK: - 动效
    public enum Motion {
        public static let micro: Animation = .easeOut(duration: 0.12)
        public static let panel: Animation = .easeInOut(duration: 0.2)
        public static let dialog: Animation = .spring(response: 0.32, dampingFraction: 0.86)
        public static let cardIn: Animation = .spring(response: 0.32, dampingFraction: 0.86)
        public static let spinner: Animation = .linear(duration: 0.9)
    }

    /// 根据系统外观生成浅色或深色颜色。
    public static func adaptive(light: UInt32, dark: UInt32) -> Color {
        Color(nsColor: NSColor(name: nil, dynamicProvider: { appearance in
            let darkMode = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            return NSColor(hex: darkMode ? dark : light)
        }))
    }
}

public extension Color {
    init(hex: UInt32) {
        self.init(nsColor: NSColor(hex: hex))
    }
}

public extension NSColor {
    convenience init(hex: UInt32) {
        let r = CGFloat((hex >> 16) & 0xFF) / 255
        let g = CGFloat((hex >> 8) & 0xFF) / 255
        let b = CGFloat(hex & 0xFF) / 255
        self.init(srgbRed: r, green: g, blue: b, alpha: 1)
    }
}
