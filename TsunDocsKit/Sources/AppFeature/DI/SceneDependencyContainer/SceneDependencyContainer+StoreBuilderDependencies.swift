//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import Environment
import SearchKit
import SwiftUI
import TagKit
import TsundocCreateFeature

extension SceneDependencyContainer: TsundocListBuildable {
    // MARK: - TsundocListBuildable

    public func buildTsundocList(title: String, emptyTile: String, emptyMessage: String?, isTsundocCreationEnabled: Bool, query: TsundocListQuery) -> AnyView {
        let store = Store(initialState: TsundocListState(query: query),
                          dependency: self,
                          reducer: TsundocListReducer())
        return AnyView(TsundocList(title: title,
                                   emptyTitle: emptyTile,
                                   emptyMessage: emptyMessage,
                                   isTsundocCreationEnabled: isTsundocCreationEnabled,
                                   store: ViewStore(store: store)))
    }
}

extension SceneDependencyContainer: TagListBuildable {
    // MARK: - TagListBuildable

    public func buildTagList() -> AnyView {
        let tagControlStore = Store(initialState: TagControlState(),
                                    dependency: self,
                                    reducer: TagControlReducer())

        let filterStore = CompositeKit.Store(initialState: SearchableFilterState<Tag>(items: []),
                                             dependency: (),
                                             reducer: SearchableFilterReducer<Tag>())
            .connect(tagControlStore.connection(at: \.tags, { SearchableFilterAction.updateItems($0) }))
            .eraseToAnyStoring()

        return AnyView(TagList(store: ViewStore(store: tagControlStore),
                               filterStore: ViewStore(store: filterStore)))
    }
}

extension SceneDependencyContainer: TagMultiSelectionSheetBuildable {
    // MARK: - TagMultiSelectionSheetBuildable

    public func buildTagMultiSelectionSheet(selectedIds: Set<Tag.ID>, onDone: @escaping ([Tag]) -> Void) -> AnyView {
        let store = Store(initialState: TagMultiSelectionState(selectedIds: selectedIds),
                          dependency: self,
                          reducer: TagMultiSelectionReducer())
        return AnyView(TagMultiSelectionSheet(store: ViewStore(store: store), onDone: onDone))
    }
}

extension SceneDependencyContainer: TsundocInfoViewBuildable {
    // MARK: - TsundocInfoViewBuildable

    public func buildTsundocInfoView(tsundoc: Tsundoc) -> AnyView {
        let store = Store(initialState: TsundocInfoViewState(tsundoc: tsundoc, tags: []),
                          dependency: self,
                          reducer: TsundocInfoViewReducer())
        return AnyView(TsundocInfoView(store: ViewStore(store: store)))
    }
}

extension SceneDependencyContainer: SettingViewBuilder {
    // MARK: - SettingViewBuilder

    public func buildSettingView() -> AnyView {
        let store = Store(initialState: SettingViewState(),
                          dependency: self,
                          reducer: SettingViewReducer())
        return AnyView(SettingView(store: ViewStore(store: store)))
    }
}

extension SceneDependencyContainer: TsundocCreateViewBuildable {
    // MARK: - TsundocCreateViewBuildable

    public func buildTsundocCreateView(url: URL, onDone: @escaping (Bool) -> Void) -> AnyView {
        let store = Store(initialState: TsundocCreateViewState(url: url),
                          dependency: self,
                          reducer: TsundocCreateViewReducer())
        return AnyView(TsundocCreateView(ViewStore(store: store), onDone: onDone))
    }
}
