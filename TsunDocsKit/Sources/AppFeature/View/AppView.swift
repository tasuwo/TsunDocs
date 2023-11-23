//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import Environment
import SplitView
import SwiftUI

#if os(iOS)

public struct AppView<Container>: View where Container: DependencyContainer {
    // MARK: - Properties

    @AppStorage(StorageKey.userInterfaceStyle.rawValue) var userInterfaceStyle = UserInterfaceStyle.unspecified

    @State var menuSelection: TabItem = .tsundocList

    @StateObject var tsundocListTabStackContainer: NavigationStackDependencyContainer
    @StateObject var tagListStackContainer: NavigationStackDependencyContainer
    @StateObject var settingTabStackContainer: NavigationStackDependencyContainer

    // MARK: - Initializers

    public init(container: Container) {
        let tsundocListTabStackContainer = NavigationStackDependencyContainer(container: container)
        let tagListStackContainer = NavigationStackDependencyContainer(container: container)
        let settingTabStackContainer = NavigationStackDependencyContainer(container: container)
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
        RootView(tsundocList: {
            NavigationStack(path: $tsundocListTabStackContainer.stack) {
                tsundocListTabStackContainer.buildTsundocList(title: L10n.tsundocListTitle,
                                                              emptyTile: L10n.tsundocListEmptyMessageDefaultTitle,
                                                              emptyMessage: L10n.tsundocListEmptyMessageDefaultMessage,
                                                              isTsundocCreationEnabled: true,
                                                              query: .all)
                    .navigationDestination(for: AppRoute.TsundocInfo.self) { [tsundocListTabStackContainer] route in
                        tsundocListTabStackContainer.buildTsundocInfoView(tsundoc: route.tsundoc)
                            .environment(\.tagMultiSelectionSheetBuilder, tsundocListTabStackContainer)
                            .environment(\.tsundocCreateViewBuilder, tsundocListTabStackContainer)
                    }
            }
            .environment(\.tagMultiSelectionSheetBuilder, tsundocListTabStackContainer)
            .environment(\.tsundocCreateViewBuilder, tsundocListTabStackContainer)
        }, tags: {
            NavigationStack(path: $tagListStackContainer.stack) {
                tagListStackContainer.buildTagList()
                    .navigationDestination(for: AppRoute.TsundocList.self) { [tagListStackContainer] tsundocList in
                        tagListStackContainer.buildTsundocList(title: tsundocList.title,
                                                               emptyTile: tsundocList.emptyTitle,
                                                               emptyMessage: tsundocList.emptyMessage,
                                                               isTsundocCreationEnabled: tsundocList.isTsundocCreationEnabled,
                                                               query: tsundocList.query)
                            .environment(\.tagMultiSelectionSheetBuilder, tagListStackContainer)
                            .environment(\.tsundocCreateViewBuilder, tagListStackContainer)
                    }
                    .navigationDestination(for: AppRoute.TsundocInfo.self) { [tagListStackContainer] route in
                        tagListStackContainer.buildTsundocInfoView(tsundoc: route.tsundoc)
                            .environment(\.tagMultiSelectionSheetBuilder, tagListStackContainer)
                            .environment(\.tsundocCreateViewBuilder, tagListStackContainer)
                    }
            }
            .environment(\.tagMultiSelectionSheetBuilder, tagListStackContainer)
            .environment(\.tsundocCreateViewBuilder, tagListStackContainer)
        }, settings: {
            NavigationStack(path: $settingTabStackContainer.stack) {
                // swiftlint:disable:next force_cast force_unwrapping
                settingTabStackContainer.buildSettingView(appVersion: Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
            }
            .environment(\.tagMultiSelectionSheetBuilder, settingTabStackContainer)
            .environment(\.tsundocCreateViewBuilder, settingTabStackContainer)
        })
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

        func buildSettingView(appVersion: String) -> AnyView {
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
