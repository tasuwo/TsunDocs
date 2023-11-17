//
//  Copyright ©︎ 2023 Tasuku Tozawa. All rights reserved.
//

import SplitView
import SwiftUI

public struct RootView<TsundocListView, TagsView, SettingsView>: View where TsundocListView: View, TagsView: View, SettingsView: View {
    @ViewBuilder private let tsundocListView: () -> TsundocListView
    @ViewBuilder private let tagsView: () -> TagsView
    @ViewBuilder private let settingsView: () -> SettingsView

    @State private var selection: TabItem = .tsundocList
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    public init(@ViewBuilder tsundocList: @escaping () -> TsundocListView,
                @ViewBuilder tags: @escaping () -> TagsView,
                @ViewBuilder settings: @escaping () -> SettingsView)
    {
        tsundocListView = tsundocList
        tagsView = tags
        settingsView = settings
    }

    public var body: some View {
        if idiom == .pad, horizontalSizeClass == .regular {
            SplitView(title: "TsunDocs", selection: $selection) {
                switch selection {
                case .tsundocList:
                    tsundocListView()

                case .tags:
                    tagsView()

                case .settings:
                    settingsView()
                }
            }
            .ignoresSafeArea()
        } else {
            TabView(selection: $selection) {
                // HACK: Stackの初期化に失敗するケースがあるので、ZStackで囲む
                ZStack { tsundocListView() }
                    .tabItem { TabItem.tsundocList.tabIcon }
                    .tag(TabItem.tsundocList)

                // HACK: Stackの初期化に失敗するケースがあるので、ZStackで囲む
                ZStack { tagsView() }
                    .tabItem { TabItem.tags.tabIcon }
                    .tag(TabItem.tags)

                // HACK: Stackの初期化に失敗するケースがあるので、ZStackで囲む
                ZStack { settingsView() }
                    .tabItem { TabItem.settings.tabIcon }
                    .tag(TabItem.settings)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView {
            Color.red
        } tags: {
            Color.blue
        } settings: {
            Color.green
        }
    }
}
