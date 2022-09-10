//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import Environment
import SwiftUI

#if os(iOS)

public typealias SceneContainer = DependencyContainer & ObservableObject

public struct RootView<Container>: View where Container: SceneContainer {
    // MARK: - Properties

    @AppStorage(StorageKey.userInterfaceStyle.rawValue) var userInterfaceStyle = UserInterfaceStyle.unspecified

    @State var menuSelection: TabItem? = .tsundocList

    @StateObject var tsundocListTabStackContainer: NavigationStackDependencyContainer
    @StateObject var tagListStackContainer: NavigationStackDependencyContainer
    @StateObject var settingTabStackContainer: NavigationStackDependencyContainer

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    // MARK: - Initializers

    public init(container: Container) {
        let tsundocListTabStackContainer = NavigationStackDependencyContainer(router: .init(), container: container)
        let tagListStackContainer = NavigationStackDependencyContainer(router: .init(), container: container)
        let settingTabStackContainer = NavigationStackDependencyContainer(router: .init(), container: container)
        _tsundocListTabStackContainer = StateObject(wrappedValue: tsundocListTabStackContainer)
        _tagListStackContainer = StateObject(wrappedValue: tagListStackContainer)
        _settingTabStackContainer = StateObject(wrappedValue: settingTabStackContainer)
    }

    // MARK: - View

    public var body: some View {
        content()
            .preferredColorScheme(userInterfaceStyle.colorScheme)
    }

    @ViewBuilder
    func content() -> some View {
        if idiom == .pad {
            NavigationSplitView {
                List(TabItem.allCases, id: \.self, selection: $menuSelection) { item in
                    item.label
                }
            } detail: {
                switch menuSelection {
                case .tsundocList, .none:
                    NavigationStack(path: $tsundocListTabStackContainer.stackRouter.stack) {
                        tsundocList()
                            .navigationDestination(for: AppRoute.TsundocInfo.self) { route in
                                tsundocListTabStackContainer.buildTsundocInfoView(tsundoc: route.tsundoc)
                            }
                    }

                case .tags:
                    NavigationStack(path: $tagListStackContainer.stackRouter.stack) {
                        tagList()
                            .navigationDestination(for: AppRoute.TsundocList.self) { tsundocList in
                                tagListStackContainer.buildTsundocList(title: tsundocList.title,
                                                                       emptyTile: tsundocList.emptyTitle,
                                                                       emptyMessage: tsundocList.emptyMessage,
                                                                       isTsundocCreationEnabled: tsundocList.isTsundocCreationEnabled,
                                                                       query: tsundocList.query)
                            }
                            .navigationDestination(for: AppRoute.TsundocInfo.self) { route in
                                tsundocListTabStackContainer.buildTsundocInfoView(tsundoc: route.tsundoc)
                            }
                    }

                case .settings:
                    NavigationStack(path: $settingTabStackContainer.stackRouter.stack) {
                        settingView()
                    }
                }
            }
        } else {
            TabView(selection: Binding(get: { menuSelection ?? .tsundocList }, set: { menuSelection = $0 })) {
                NavigationStack(path: $tsundocListTabStackContainer.stackRouter.stack) {
                    tsundocList()
                        .navigationDestination(for: AppRoute.TsundocInfo.self) { route in
                            tsundocListTabStackContainer.buildTsundocInfoView(tsundoc: route.tsundoc)
                        }
                }
                .tabItem { TabItem.tsundocList.view }
                .tag(TabItem.tsundocList)

                NavigationStack(path: $tagListStackContainer.stackRouter.stack) {
                    tagList()
                        .navigationDestination(for: AppRoute.TsundocList.self) { tsundocList in
                            tagListStackContainer.buildTsundocList(title: tsundocList.title,
                                                                   emptyTile: tsundocList.emptyTitle,
                                                                   emptyMessage: tsundocList.emptyMessage,
                                                                   isTsundocCreationEnabled: tsundocList.isTsundocCreationEnabled,
                                                                   query: tsundocList.query)
                        }
                        .navigationDestination(for: AppRoute.TsundocInfo.self) { route in
                            tsundocListTabStackContainer.buildTsundocInfoView(tsundoc: route.tsundoc)
                        }
                }
                .tabItem { TabItem.tags.view }
                .tag(TabItem.tags)

                NavigationStack(path: $settingTabStackContainer.stackRouter.stack) {
                    settingView()
                }
                .tabItem { TabItem.settings.view }
                .tag(TabItem.settings)
            }
        }
    }

    @ViewBuilder
    func tsundocList() -> some View {
        tsundocListTabStackContainer.buildTsundocList(title: L10n.tsundocListTitle,
                                                      emptyTile: L10n.tsundocListEmptyMessageDefaultTitle,
                                                      emptyMessage: L10n.tsundocListEmptyMessageDefaultMessage,
                                                      isTsundocCreationEnabled: true,
                                                      query: .all)
            .environment(\.tsundocListBuilder, tsundocListTabStackContainer)
            .environment(\.tagListBuilder, tsundocListTabStackContainer)
            .environment(\.tagMultiSelectionSheetBuilder, tsundocListTabStackContainer)
            .environment(\.tsundocInfoViewBuilder, tsundocListTabStackContainer)
            .environment(\.tsundocCreateViewBuilder, tsundocListTabStackContainer)
    }

    @ViewBuilder
    func tagList() -> some View {
        tagListStackContainer.buildTagList()
            .environment(\.tsundocListBuilder, tagListStackContainer)
            .environment(\.tagListBuilder, tagListStackContainer)
            .environment(\.tagMultiSelectionSheetBuilder, tagListStackContainer)
            .environment(\.tsundocInfoViewBuilder, tagListStackContainer)
            .environment(\.tsundocCreateViewBuilder, tagListStackContainer)
    }

    @ViewBuilder
    func settingView() -> some View {
        settingTabStackContainer.buildSettingView()
            .environment(\.tsundocListBuilder, settingTabStackContainer)
            .environment(\.tagListBuilder, settingTabStackContainer)
            .environment(\.tagMultiSelectionSheetBuilder, settingTabStackContainer)
            .environment(\.tsundocInfoViewBuilder, settingTabStackContainer)
            .environment(\.tsundocCreateViewBuilder, settingTabStackContainer)
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
        SettingViewBuilder,
        TsundocCreateViewBuildable
    {
        func buildTsundocList(title: String, emptyTile: String, emptyMessage: String?, isTsundocCreationEnabled: Bool, query: TsundocListQuery) -> AnyView {
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

        func buildTsundocCreateView(url: URL, onDone: @escaping (Bool) -> Void) -> AnyView {
            AnyView(Color.pink)
        }
    }

    static var previews: some View {
        Group {
            // TODO:
            EmptyView()
            // RootView(container: DummyContainer())
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
