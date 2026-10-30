//
//  BrandComponents.swift
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

import SwiftUI

// MARK: - 按钮

public enum BrandButtonKind {
    /// 主按钮：ink 底 onInk 文
    case primary
    /// 次按钮：bgCard 底 borderStrong 描边
    case secondary
    /// 强调按钮：accent 底白文
    case accent
    /// 危险按钮：dangerBg 底 dangerBorder 描边 dangerText 文
    case danger
    /// ghost：无底无边框，次要入口
    case ghost
    /// 浅强调：accentBgSoft 底 accentBorder 描边 accentTextDeep 文（与 accent 同族不同档）
    case accentSoft
    /// 浅正向：okBg 底 okBorder 描边 okText 文（免费/正向动作，如申请试用）
    case okSoft
}

public struct BrandButton: View {
    let title: String
    let kind: BrandButtonKind
    let disabled: Bool
    let action: () -> Void

    public init(_ title: String, kind: BrandButtonKind = .primary,
                disabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.kind = kind
        self.disabled = disabled
        self.action = action
    }

    @State private var hovering = false

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .frame(maxWidth: .infinity, minHeight: 32)
        }
        .buttonStyle(.plain)
        .foregroundStyle(foreground)
        .background(background)
        .overlay(
            RoundedRectangle(cornerRadius: MTheme.Radius.m2)
                .strokeBorder(border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: MTheme.Radius.m2))
        .opacity(disabled ? 0.5 : 1)
        .scaleEffect(hovering && !disabled ? 1.0 : 1.0)
        .animation(MTheme.Motion.micro, value: hovering)
        .onHover { hovering = $0 }
        .disabled(disabled)
    }

    private var foreground: Color {
        if disabled { return MTheme.textDisabled }
        switch kind {
        case .primary: return MTheme.onInk
        case .secondary: return MTheme.textPrimary
        case .accent: return .white
        case .danger: return MTheme.dangerText
        case .ghost: return MTheme.textSecondary
        case .accentSoft: return MTheme.accentTextDeep
        case .okSoft: return MTheme.okText
        }
    }

    private var background: Color {
        if disabled { return MTheme.bgActive }
        switch kind {
        case .primary: return hovering ? MTheme.inkHover : MTheme.ink
        case .secondary: return hovering ? MTheme.bgHover : MTheme.bgCard
        case .accent: return hovering ? MTheme.accentHover : MTheme.accent
        case .danger: return MTheme.dangerBg
        case .ghost: return hovering ? MTheme.bgHover : .clear
        case .accentSoft: return hovering ? MTheme.accentBorder.opacity(0.45) : MTheme.accentBgSoft
        case .okSoft: return hovering ? MTheme.okBorder.opacity(0.45) : MTheme.okBg
        }
    }

    private var border: Color {
        switch kind {
        case .secondary: return MTheme.borderStrong
        case .danger: return MTheme.dangerBorder
        case .accentSoft: return MTheme.accentBorder
        case .okSoft: return MTheme.okBorder
        default: return .clear
        }
    }
}

// MARK: - 输入框（输入框布局与聚焦状态；
//  常态 borderStrong 1px，聚焦 accent 1.5px + 外环 accentBorder 3px，错误 danger 1.5px）

public struct BrandTextField: View {
    let placeholder: String
    @Binding var text: String
    var hasError: Bool = false
    var font: Font = MTheme.Typo.body
    var height: CGFloat = 36

    public init(_ placeholder: String, text: Binding<String>,
                hasError: Bool = false, font: Font = MTheme.Typo.body, height: CGFloat = 36) {
        self.placeholder = placeholder
        _text = text
        self.hasError = hasError
        self.font = font
        self.height = height
    }

    @FocusState private var focused: Bool

    public var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(.plain)
            .font(font)
            .padding(.horizontal, 12)
            .frame(height: height)
            .background(MTheme.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: MTheme.Radius.m2))
            .overlay(
                RoundedRectangle(cornerRadius: MTheme.Radius.m2)
                    .strokeBorder(
                        hasError ? MTheme.danger : (focused ? MTheme.accent : MTheme.borderStrong),
                        lineWidth: (hasError || focused) ? 1.5 : 1)
            )
            .overlay(
                // 聚焦外环 3px
                RoundedRectangle(cornerRadius: MTheme.Radius.m2 + 2)
                    .strokeBorder(MTheme.accentBorder, lineWidth: 3)
                    .opacity(focused && !hasError ? 1 : 0)
                    .allowsHitTesting(false)
            )
            .focused($focused)
            .animation(MTheme.Motion.micro, value: focused)
    }
}

// MARK: - 验证码格（数字输入格；
//  自动逐格前进、支持整串粘贴；错误时整组 danger 描边 + 水平晃动 240ms）

public struct CodeDigitField: View {
    @Binding var code: String
    var digitCount: Int = 6
    /// 格子尺寸（登录 48×56；解绑弹窗 44×50）
    var cellSize: CGSize = CGSize(width: 48, height: 56)
    var cellSpacing: CGFloat = 10
    var hasError: Bool = false

    public init(code: Binding<String>, digitCount: Int = 6,
                cellSize: CGSize = CGSize(width: 48, height: 56),
                cellSpacing: CGFloat = 10, hasError: Bool = false) {
        _code = code
        self.digitCount = digitCount
        self.cellSize = cellSize
        self.cellSpacing = cellSpacing
        self.hasError = hasError
    }

    @FocusState private var focused: Bool
    @State private var shakeOffset: CGFloat = 0

    public var body: some View {
        ZStack {
            // 隐藏输入通道：覆盖整组格子，接收键入与粘贴
            TextField("", text: filteredBinding)
                .textFieldStyle(.plain)
                .focused($focused)
                .opacity(0.01)
                .allowsHitTesting(false)

            HStack(spacing: cellSpacing) {
                ForEach(0..<digitCount, id: \.self) { index in
                    cell(at: index)
                }
            }
        }
        .offset(x: shakeOffset)
        .onChange(of: hasError) { _, newValue in
            if newValue { shake() }
        }
        .onAppear { focused = true }
        .contentShape(Rectangle())
        .onTapGesture { focused = true }
    }

    private var filteredBinding: Binding<String> {
        Binding(
            get: { code },
            set: { newValue in
                let digits = newValue.filter(\.isNumber)
                code = String(digits.prefix(digitCount))
            }
        )
    }

    @ViewBuilder
    private func cell(at index: Int) -> some View {
        let digits = Array(code)
        let isCurrent = index == min(code.count, digitCount - 1) && focused
        ZStack {
            RoundedRectangle(cornerRadius: MTheme.Radius.m2)
                .fill(MTheme.bgCard)
                .overlay(
                    RoundedRectangle(cornerRadius: MTheme.Radius.m2)
                        .strokeBorder(
                            hasError ? MTheme.danger
                                : (isCurrent ? MTheme.accent : MTheme.borderStrong),
                            lineWidth: (hasError || isCurrent) ? 1.5 : 1)
                )
            if index < digits.count {
                Text(String(digits[index]))
                    .font(.system(size: 22, weight: .medium).monospacedDigit())
                    .foregroundStyle(MTheme.textPrimary)
            }
        }
        .frame(width: cellSize.width, height: cellSize.height)
    }

    /// 错误晃动：幅度 8、两来回、240ms
    private func shake() {
        withAnimation(.linear(duration: 0.24).repeatCount(2, autoreverses: true)) {
            shakeOffset = 8
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            shakeOffset = 0
        }
    }
}

// MARK: - 提示条

public enum BrandBannerTone {
    case info, success, warning, error

    var icon: String {
        switch self {
        case .info: return "info.circle"
        case .success: return "checkmark.circle"
        case .warning: return "exclamationmark.triangle"
        case .error: return "xmark.circle"
        }
    }

    var background: Color {
        switch self {
        case .info: return MTheme.accentBgSoft
        case .success: return MTheme.okBg
        case .warning: return MTheme.warnBg
        case .error: return MTheme.dangerBg
        }
    }

    var border: Color {
        switch self {
        case .info: return MTheme.accentBorder
        case .success: return MTheme.okBorder
        case .warning: return MTheme.warnBorder
        case .error: return MTheme.dangerBorder
        }
    }

    var foreground: Color {
        switch self {
        case .info: return MTheme.accentTextDeep
        case .success: return MTheme.okText
        case .warning: return MTheme.warnText
        case .error: return MTheme.dangerText
        }
    }
}

public struct BrandBanner: View {
    let tone: BrandBannerTone
    let text: String

    public init(_ tone: BrandBannerTone, _ text: String) {
        self.tone = tone
        self.text = text
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: tone.icon)
                .font(.system(size: 16))
            Text(text)
                .font(MTheme.Typo.caption)
            Spacer(minLength: 0)
        }
        .foregroundStyle(tone.foreground)
        .padding(.horizontal, 16)
        .frame(minHeight: 40)
        .background(tone.background)
        .overlay(
            RoundedRectangle(cornerRadius: MTheme.Radius.m2)
                .strokeBorder(tone.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: MTheme.Radius.m2))
    }
}

// MARK: - 徽标 chip

public struct BrandChip: View {
    let text: String
    let tone: BrandBannerTone

    public init(_ text: String, tone: BrandBannerTone) {
        self.text = text
        self.tone = tone
    }

    public var body: some View {
        Text(text)
            .font(MTheme.Typo.micro)
            .foregroundStyle(tone.foreground)
            .padding(.horizontal, 12)
            .frame(height: 24)
            .background(tone.background)
            .overlay(
                Capsule().strokeBorder(tone.border, lineWidth: 1)
            )
            .clipShape(Capsule())
    }
}

// MARK: - 品牌弹窗骨架（弹窗容器；
//  遮罩黑 30%；标题 14 Semibold、正文 12 textSecondary）

public struct BrandDialog<Content: View>: View {
    let width: CGFloat
    @ViewBuilder var content: Content

    public init(width: CGFloat = 400, @ViewBuilder content: () -> Content) {
        self.width = width
        self.content = content()
    }

    public var body: some View {
        content
            .padding(24)
            .frame(width: width)
            // 保持内容的理想高度，避免弹窗被父容器拉伸。
            .fixedSize(horizontal: false, vertical: true)
            .background(MTheme.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: MTheme.Radius.l))
            .shadow(color: MTheme.Shadow.popover().color,
                    radius: MTheme.Shadow.popover().radius,
                    y: MTheme.Shadow.popover().y)
    }
}

/// 遮罩 + 居中弹窗的容器（遮罩黑 30%，点遮罩不关闭——关键确认框防误触）
public struct BrandModalOverlay<Content: View>: View {
    let width: CGFloat
    @ViewBuilder var content: Content

    public init(width: CGFloat = 400, @ViewBuilder content: () -> Content) {
        self.width = width
        self.content = content()
    }

    public var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            BrandDialog(width: width) { content }
                .transition(.scale(scale: 0.96).combined(with: .opacity))
        }
        .animation(MTheme.Motion.dialog, value: true)
    }
}

// MARK: - 登录系点阵背景（背景色、顶部渐变
//  + 点阵（间距 30、点径 1.1））

public struct BrandAuthBackground: View {
    public init() {}

    public var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                // 底色
                context.fill(
                    Path(CGRect(origin: .zero, size: size)),
                    with: .color(MTheme.bgApp))
                // 顶部柔光带
                let gradient = Gradient(colors: [MTheme.accentBgSoft, MTheme.bgApp])
                context.fill(
                    Path(CGRect(x: 0, y: 0, width: size.width, height: min(420, size.height))),
                    with: .linearGradient(gradient, startPoint: .zero, endPoint: CGPoint(x: 0, y: 420)))
                // 点阵
                let spacing: CGFloat = 30
                let radius: CGFloat = 1.1
                var x: CGFloat = spacing / 2
                while x < size.width {
                    var y: CGFloat = spacing / 2
                    while y < size.height {
                        context.fill(
                            Path(ellipseIn: CGRect(x: x - radius, y: y - radius,
                                                   width: radius * 2, height: radius * 2)),
                            with: .color(MTheme.dotGrid))
                        y += spacing
                    }
                    x += spacing
                }
            }
            .ignoresSafeArea()
        }
    }
}
