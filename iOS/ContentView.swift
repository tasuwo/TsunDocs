//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import SwiftUI

struct ContentView: View {
    // MARK: - Properties

    @StateObject var container: SceneDependencyContainer

    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    // MARK: - View

    var body: some View {
        content()
            .environment(\.tsundocListStoreBuilder, container)
            .environment(\.tagMultiAdditionViewStoreBuilder, container)
            .environment(\.tagListStoreBuilder, container)
            .environment(\.tsundocInfoViewStoreBuilder, container)
    }

    @ViewBuilder
    func content() -> some View {
        let tsundocListStore = container.buildTsundocListStore(query: .all)
        let tagListStore = container.buildTagListStore()
        let tsundocList = NavigationView {
            TsundocList(title: L10n.tsundocListTitle,
                        emptyTitle: L10n.tsundocListEmptyMessageDefaultTitle,
                        emptyMessage: L10n.tsundocListEmptyMessageDefaultMessage,
                        store: tsundocListStore)
        }
        // HACK: https://forums.swift.org/t/14-5-beta3-navigationlink-unexpected-pop/45279/35
        .navigationViewStyle(StackNavigationViewStyle())

        if idiom == .pad {
            NavigationView {
                List {
                    NavigationLink(destination: tsundocList) {
                        TabItem.tsundocList.label
                    }
                    NavigationLink(destination: TagList(store: tagListStore)) {
                        TabItem.tags.label
                    }
                    NavigationLink(destination: SettingView()) {
                        TabItem.settings.label
                    }
                }
                .navigationTitle(LocalizedStringKey("app_name"))
                .listStyle(SidebarListStyle())

                tsundocList
            }
        } else {
            TabView {
                tsundocList
                    .tabItem { TabItem.tsundocList.view }

                TagList(store: tagListStore)
                    .tabItem { TabItem.tags.view }

                SettingView()
                    .tabItem { TabItem.settings.view }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(container: SceneDependencyContainer(AppDependencyContainer()))
                .previewDevice("iPhone 12")

            ContentView(container: SceneDependencyContainer(AppDependencyContainer()))
                .previewDevice("iPad Pro (12.9-inch) (3rd generation)")
        }
    }
}
