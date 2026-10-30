//
//  RootNavigation.swift
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

/// 左侧栏条目：会话、新建模型、模型管理、探索知识库、设置。
enum SidebarItem: String, CaseIterable, Identifiable {
    case chat
    case newModel
    case manage
    case explorationKB
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .chat: return "会话"
        case .newModel: return "新建模型"
        case .manage: return "模型管理"
        case .explorationKB: return "探索知识库"
        case .settings: return "设置"
        }
    }

    var icon: String {
        switch self {
        case .chat: return "bubble.left"
        case .newModel: return "plus.square"
        case .manage: return "square.stack.3d.up"
        case .explorationKB: return "books.vertical"
        case .settings: return "gearshape"
        }
    }

    /// 「新建模型」是动作条目：点击打开创建向导，不进选中态（键盘高亮也跳过它）；
    /// 其余四项是页面条目，有选中高亮态
    var isAction: Bool { self == .newModel }
}

/// 主区域页面由显式状态机表示，侧栏保持常驻。
enum Page: Equatable {
    case chat
    case settings
    case models
    case modelDetail(UUID)
    /// 用户级探索知识库
    case explorationKB
}

/// 导航状态机。
/// 所有页面切换都走这里的显式方法，不依赖「绑定值变化才触发」的隐式联动，
/// 因此「重复点击同一项」也一定能切到目标页。
@MainActor
final class RootNavigation: ObservableObject {

    /// 当前主区域页面（默认模型管理）
    @Published private(set) var page: Page = .models
    /// 左侧栏选中态（高亮用）
    @Published var sidebarSelection: SidebarItem? = .manage
    /// 是否显示新建模型向导
    @Published var showingWizard = false

    /// 点击左侧栏「会话」
    func tapChat() {
        // 从详情进入会话时保留当前模型选择
        if case .modelDetail(let id) = page {
            chatPreferredModelID = id
        }
        sidebarSelection = .chat
        page = .chat
    }

    /// 点击左侧栏「新建模型」：打开创建向导（动作条目，不进选中态）
    func tapNewModel() {
        showingWizard = true
    }

    /// 点击左侧栏「模型管理」：无论当前在哪一页，都回到模型列表
    func tapManage() {
        sidebarSelection = .manage
        page = .models
    }

    /// 打开探索知识库
    func openExplorationKB() {
        sidebarSelection = .explorationKB
        page = .explorationKB
    }

    /// 点击左侧栏「设置」
    func tapSettings() {
        sidebarSelection = .settings
        page = .settings
    }

    /// 进入模型详情，侧栏高亮保持在模型管理。
    func openModelDetail(_ id: UUID) {
        sidebarSelection = .manage
        page = .modelDetail(id)
    }

    /// 详情页返回模型列表
    func backToModels() {
        page = .models
    }

    /// 键盘高亮与点击统一汇入相同的导航方法。
    /// （「新建模型」是动作条目不入选中值，键盘导航天然跳过它。）
    func sidebarHighlightChanged(to item: SidebarItem?) {
        guard let item, !item.isAction else { return }
        switch item {
        case .chat: tapChat()
        case .manage: tapManage()
        case .explorationKB: openExplorationKB()
        case .settings: tapSettings()
        case .newModel: break
        }
    }

    /// 会话页应优先选择的模型，消费一次即清空
    @Published private(set) var chatPreferredModelID: UUID?

    /// 会话页消费联动意图：取走并清空（一次性）
    func consumeChatPreferredModel() -> UUID? {
        defer { chatPreferredModelID = nil }
        return chatPreferredModelID
    }

    /// 创建向导完成：回到模型列表
    func wizardCompleted() {
        sidebarSelection = .manage
        page = .models
        showingWizard = false
    }
}
