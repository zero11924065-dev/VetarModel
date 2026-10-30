//
//  MCallout.swift
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
//  VetarModel 通用 SwiftUI 提示条。
//

import SwiftUI

public enum MCalloutKind {
    case info, success, warn, error

    var icon: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warn: return "exclamationmark.triangle.fill"
        case .error: return "xmark.octagon.fill"
        }
    }
    var background: Color {
        switch self {
        case .info: return MTheme.accentBgSoft
        case .success: return MTheme.okBg
        case .warn: return MTheme.warnBg
        case .error: return MTheme.dangerBg
        }
    }
    var border: Color {
        switch self {
        case .info: return MTheme.accentBorder
        case .success: return MTheme.okBorder
        case .warn: return MTheme.warnBorder
        case .error: return MTheme.dangerBorder
        }
    }
    var foreground: Color {
        switch self {
        case .info: return MTheme.accentTextDeep
        case .success: return MTheme.okText
        case .warn: return MTheme.warnText
        case .error: return MTheme.dangerText
        }
    }
}

public struct MCallout: View {
    public let kind: MCalloutKind
    public let text: String

    public init(_ kind: MCalloutKind, _ text: String) {
        self.kind = kind
        self.text = text
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: kind.icon)
                .font(.system(size: 12))
                .padding(.top, 1)
            Text(text)
                .font(MTheme.Typo.body)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .foregroundStyle(kind.foreground)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(kind.background, in: RoundedRectangle(cornerRadius: MTheme.Radius.s))
        .overlay(RoundedRectangle(cornerRadius: MTheme.Radius.s).stroke(kind.border))
    }
}
