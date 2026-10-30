//
//  FoldRow.swift
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

/// 整行可点的折叠组。标题行任意位置均可展开或收起，箭头仅作状态指示。
struct FoldRow<Label: View, Content: View>: View {
    @Binding var isExpanded: Bool
    let label: Label
    let content: Content

    init(
        isExpanded: Binding<Bool>,
        @ViewBuilder label: () -> Label,
        @ViewBuilder content: () -> Content
    ) {
        self._isExpanded = isExpanded
        self.label = label()
        self.content = content()
    }

    /// 使用字符串作为标题的便捷入口。
    init(
        _ title: String,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) where Label == Text {
        self.init(isExpanded: isExpanded, label: { Text(title) }, content: content)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.15)) { isExpanded.toggle() }
            } label: {
                HStack(spacing: 6) {
                    label
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityHint(isExpanded ? "已展开，点按收起" : "已收起，点按展开")
            if isExpanded {
                content
                    .padding(.top, 6)
                    .transition(.opacity)
            }
        }
    }
}
