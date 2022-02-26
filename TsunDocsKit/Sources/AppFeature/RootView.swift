//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

#if os(iOS)

public struct RootView: View {
    // MARK: - Properties

    @AppStorage(StorageKey.userInterfaceStyle.rawValue) var userInterfaceStyle = UserInterfaceStyle.unspecified
    @StateObject var container: SceneDependencyContainer

    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    // MARK: - Initializers

    public init(container: SceneDependencyContainer) {
        _container = StateObject(wrappedValue: container)
    }

    // MARK: - View

    public var body: some View {
        content()
            .environment(\.tsundocListStoreBuilder, container)
            .environment(\.tagControlViewStoreBuilder, container)
            .environment(\.tagMultiSelectionStoreBuilder, container)
            .environment(\.tsundocInfoViewStoreBuilder, container)
            .preferredColorScheme(userInterfaceStyle.colorScheme)
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
        SettingView(store: container.buildSettingViewStore())
    }
}

private extension UserInterfaceStyle {
    var colorScheme: ColorScheme? {
        switch self {
        case .dark:
            return .dark

        case .light:
            return .light

        case .unspecified:
            return nil
        }
    }
}

#elseif os(macOS)

struct RootView: View {
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

#endif
