//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import Environment
import MobileSettingFeature
import SwiftUI
import TagListFeature
import TagMultiSelectionFeature
import TsundocCreateFeature
import TsundocInfoFeature
import TsundocListFeature

extension NavigationStackDependencyContainer: TsundocListBuildable {
    // MARK: - TsundocListBuildable

    public typealias TsundocList = TsundocListFeature.TsundocList

    public func buildTsundocList(title: String, emptyTile: String, emptyMessage: String?, isTsundocCreationEnabled: Bool, query: TsundocListQuery) -> TsundocList {
        let store = Store(initialState: TsundocListState(query: query),
                          dependency: self,
                          reducer: TsundocListReducer())
        return TsundocList(title: title,
                           emptyTitle: emptyTile,
                           emptyMessage: emptyMessage,
                           isTsundocCreationEnabled: isTsundocCreationEnabled,
                           store: ViewStore(store: store))
    }
}

extension NavigationStackDependencyContainer: TagListBuildable {
    // MARK: - TagListBuildable

    public typealias TagList = TagListFeature.TagList

    public func buildTagList() -> TagList {
        let tagControlStore = Store(initialState: TagControlState(),
                                    dependency: self,
                                    reducer: TagControlReducer())

        let filterStore = CompositeKit.Store(initialState: SearchableFilterState<Tag>(items: []),
                                             dependency: (),
                                             reducer: SearchableFilterReducer<Tag>())
            .connect(tagControlStore.connection(at: \.tags, { SearchableFilterAction.updateItems($0) }))
            .eraseToAnyStoring()

        return TagList(store: ViewStore(store: tagControlStore),
                       filterStore: ViewStore(store: filterStore))
    }
}

extension NavigationStackDependencyContainer: TagMultiSelectionSheetBuildable {
    // MARK: - TagMultiSelectionSheetBuildable

    public typealias TagMultiSelectionSheet = TagMultiSelectionFeature.TagMultiSelectionSheet

    public func buildTagMultiSelectionSheet(selectedIds: Set<Tag.ID>, onDone: @escaping ([Tag]) -> Void) -> TagMultiSelectionSheet {
        let store = Store(initialState: TagMultiSelectionState(selectedIds: selectedIds),
                          dependency: self,
                          reducer: TagMultiSelectionReducer())
        return TagMultiSelectionSheet(store: ViewStore(store: store), onDone: onDone)
    }
}

extension NavigationStackDependencyContainer: TsundocInfoViewBuildable {
    // MARK: - TsundocInfoViewBuildable

    public typealias TsundocInfoView = TsundocInfoFeature.TsundocInfoView

    public func buildTsundocInfoView(tsundoc: Tsundoc) -> TsundocInfoView {
        let store = Store(initialState: TsundocInfoViewState(tsundoc: tsundoc, tags: []),
                          dependency: self,
                          reducer: TsundocInfoViewReducer())
        return TsundocInfoView(store: ViewStore(store: store))
    }
}

extension NavigationStackDependencyContainer: SettingViewBuilder {
    // MARK: - SettingViewBuilder

    public typealias SettingView = MobileSettingFeature.SettingView

    public func buildSettingView(appVersion: String) -> SettingView {
        let store = Store(initialState: SettingViewState(appVersion: appVersion),
                          dependency: self,
                          reducer: SettingViewReducer())
        return SettingView(store: ViewStore(store: store))
    }
}

extension NavigationStackDependencyContainer: TsundocCreateViewBuildable {
    // MARK: - TsundocCreateViewBuildable

    public typealias TsundocCreateView = TsundocCreateFeature.TsundocCreateView

    public func buildTsundocCreateView(url: URL, onDone: @escaping (Bool) -> Void) -> TsundocCreateView {
        let store = Store(initialState: TsundocCreateViewState(url: url),
                          dependency: self,
                          reducer: TsundocCreateViewReducer())
        return TsundocCreateView(ViewStore(store: store), onDone: onDone)
    }
}
