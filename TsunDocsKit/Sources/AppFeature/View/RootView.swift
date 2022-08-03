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

    @StateObject var tsundocListTabStack: NavigationStackDependencyContainer
    @StateObject var tagListStack: NavigationStackDependencyContainer
    @StateObject var settingTabStack: NavigationStackDependencyContainer

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    // MARK: - Initializers

    public init(container: Container) {
        _tsundocListTabStack = StateObject(wrappedValue: NavigationStackDependencyContainer(router: .init(), container: container))
        _tagListStack = StateObject(wrappedValue: NavigationStackDependencyContainer(router: .init(), container: container))
        _settingTabStack = StateObject(wrappedValue: NavigationStackDependencyContainer(router: .init(), container: container))
    }

    // MARK: - View

    public var body: some View {
        content()
            .preferredColorScheme(userInterfaceStyle.colorScheme)
    }

    @ViewBuilder
    func content() -> some View {
        if idiom == .pad, horizontalSizeClass == .regular {
            NavigationSplitView {
                List(TabItem.allCases, id: \.self, selection: $menuSelection) { item in
                    item.label
                }
            } detail: {
                switch menuSelection {
                case .tsundocList, .none:
                    NavigationStack(path: $tsundocListTabStack.stackRouter.stack) {
                        tsundocList()
                    }

                case .tags:
                    NavigationStack(path: $tagListStack.stackRouter.stack) {
                        tagList()
                    }

                case .settings:
                    NavigationStack(path: $settingTabStack.stackRouter.stack) {
                        settingView()
                    }
                }
            }
        } else {
            TabView(selection: Binding(get: { menuSelection ?? .tsundocList }, set: { menuSelection = $0 })) {
                NavigationStack(path: $tsundocListTabStack.stackRouter.stack) {
                    tsundocList()
                }
                .tabItem { TabItem.tsundocList.view }
                .tag(TabItem.tsundocList)

                NavigationStack(path: $tagListStack.stackRouter.stack) {
                    tagList()
                }
                .tabItem { TabItem.tags.view }
                .tag(TabItem.tags)

                NavigationStack(path: $settingTabStack.stackRouter.stack) {
                    settingView()
                }
                .tabItem { TabItem.settings.view }
                .tag(TabItem.settings)
            }
        }
    }

    @ViewBuilder
    func tsundocList() -> some View {
        tsundocListTabStack.buildTsundocList(title: L10n.tsundocListTitle,
                                             emptyTile: L10n.tsundocListEmptyMessageDefaultTitle,
                                             emptyMessage: L10n.tsundocListEmptyMessageDefaultMessage,
                                             isTsundocCreationEnabled: true,
                                             query: .all)
            .environment(\.tsundocListBuilder, tsundocListTabStack)
            .environment(\.tagListBuilder, tsundocListTabStack)
            .environment(\.tagMultiSelectionSheetBuilder, tsundocListTabStack)
            .environment(\.tsundocInfoViewBuilder, tsundocListTabStack)
            .environment(\.tsundocCreateViewBuilder, tsundocListTabStack)
    }

    @ViewBuilder
    func tagList() -> some View {
        tagListStack.buildTagList()
            .environment(\.tsundocListBuilder, tagListStack)
            .environment(\.tagListBuilder, tagListStack)
            .environment(\.tagMultiSelectionSheetBuilder, tagListStack)
            .environment(\.tsundocInfoViewBuilder, tagListStack)
            .environment(\.tsundocCreateViewBuilder, tagListStack)
    }

    @ViewBuilder
    func settingView() -> some View {
        settingTabStack.buildSettingView()
            .environment(\.tsundocListBuilder, settingTabStack)
            .environment(\.tagListBuilder, settingTabStack)
            .environment(\.tagMultiSelectionSheetBuilder, settingTabStack)
            .environment(\.tsundocInfoViewBuilder, settingTabStack)
            .environment(\.tsundocCreateViewBuilder, settingTabStack)
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
