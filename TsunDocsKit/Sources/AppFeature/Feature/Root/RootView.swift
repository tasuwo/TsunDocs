//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import Environment
import SwiftUI

#if os(iOS)

public typealias SceneContainer = TsundocListBuildable
    & TagListBuildable
    & TagMultiSelectionSheetBuildable
    & TsundocInfoViewBuildable
    & SettingViewBuilder
    & ObservableObject

public struct RootView<Container>: View where Container: SceneContainer {
    // MARK: - Properties

    @AppStorage(StorageKey.userInterfaceStyle.rawValue) var userInterfaceStyle = UserInterfaceStyle.unspecified
    @StateObject var container: Container

    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    // MARK: - Initializers

    public init(container: Container) {
        _container = StateObject(wrappedValue: container)
    }

    // MARK: - View

    public var body: some View {
        content()
            .environment(\.tsundocListBuilder, container)
            .environment(\.tagListBuilder, container)
            .environment(\.tagMultiSelectionSheetBuilder, container)
            .environment(\.tsundocInfoViewBuilder, container)
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
        container.buildTsundocList(title: L10n.tsundocListTitle,
                                   emptyTile: L10n.tsundocListEmptyMessageDefaultTitle,
                                   emptyMessage: L10n.tsundocListEmptyMessageDefaultMessage,
                                   query: .all)
    }

    @ViewBuilder
    func tagList() -> some View {
        container.buildTagList()
    }

    @ViewBuilder
    func settingView() -> some View {
        container.buildSettingView()
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

struct RootView_Previews: PreviewProvider {
    private class DummyContainer: ObservableObject,
        TsundocListBuildable,
        TagListBuildable,
        TagMultiSelectionSheetBuildable,
        TsundocInfoViewBuildable,
        SettingViewBuilder
    {
        func buildTsundocList(title: String, emptyTile: String, emptyMessage: String?, query: TsundocListQuery) -> AnyView {
            AnyView(Color.red)
        }

        func buildTagList() -> AnyView {
            AnyView(Color.blue)
        }

        func buildTagMultiSelectionSheet(selectedIds: Set<Tag.ID>, onDone: @escaping ([Tag]) -> Void) -> AnyView {
            AnyView(Color.green)
        }

        func buildTsundocInfoView(tsundoc: Tsundoc) -> AnyView {
            AnyView(Color.yellow)
        }

        func buildSettingView() -> AnyView {
            AnyView(Color.black)
        }
    }

    static var previews: some View {
        Group {
            RootView(container: DummyContainer())
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
