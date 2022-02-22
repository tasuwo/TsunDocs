//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import SwiftUI

#if os(iOS)

struct ContentView: View {
    // MARK: - Properties

    @StateObject var container: SceneDependencyContainer

    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    // MARK: - View

    var body: some View {
        content()
            .environment(\.tsundocListStoreBuilder, container)
            .environment(\.tagControlViewStoreBuilder, container)
            .environment(\.tagMultiSelectionStoreBuilder, container)
            .environment(\.tsundocInfoViewStoreBuilder, container)
    }

    @ViewBuilder
    func content() -> some View {
        if idiom == .pad {
            NavigationView {
                List {
                    NavigationLink(destination: tsundocList()) {
                        TabItem.tsundocList.label
                    }

                    NavigationLink(destination: tagList()) {
                        TabItem.tags.label
                    }

                    NavigationLink(destination: settingView()) {
                        TabItem.settings.label
                    }
                }
                .navigationTitle(NSLocalizedString("app_name", bundle: .module, comment: ""))
                .listStyle(SidebarListStyle())

                tsundocList()
            }
        } else {
            TabView {
                NavigationView {
                    tsundocList()
                }
                .navigationViewStyle(.stack)
                .tabItem { TabItem.tsundocList.view }

                NavigationView {
                    tagList()
                }
                .navigationViewStyle(.stack)
                .tabItem { TabItem.tags.view }

                NavigationView {
                    settingView()
                }
                .navigationViewStyle(.stack)
                .tabItem { TabItem.settings.view }
            }
        }
    }

    @ViewBuilder
    func tsundocList() -> some View {
        TsundocList(title: L10n.tsundocListTitle,
                    emptyTitle: L10n.tsundocListEmptyMessageDefaultTitle,
                    emptyMessage: L10n.tsundocListEmptyMessageDefaultMessage,
                    store: container.buildTsundocListStore(query: .all))
    }

    @ViewBuilder
    func tagList() -> some View {
        TagList(store: container.buildTagControlViewStore())
    }

    @ViewBuilder
    func settingView() -> some View {
        SettingView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(container: SceneDependencyContainer(.shared))
                .previewDevice("iPhone 12")

            ContentView(container: SceneDependencyContainer(.shared))
                .previewDevice("iPad Pro (12.9-inch) (3rd generation)")
        }
    }
}

#elseif os(macOS)

struct ContentView: View {
    @StateObject var container: SceneDependencyContainer

    var body: some View {
        let viewStore = container.buildTsundocListStore()

        NavigationView {
            List {
                NavigationLink(destination: TsundocList(store: viewStore)) {
                    TabItem.tsundocList.label
                }
                NavigationLink(destination: Text("TODO")) {
                    TabItem.settings.label
                }
            }
            .navigationTitle(LocalizedStringKey("app_name"))
            .listStyle(SidebarListStyle())

            TsundocList(store: viewStore)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(container: SceneDependencyContainer(AppDependencyContainer()))
        }
    }
}

#endif
