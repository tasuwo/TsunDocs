//
//  Copyright © 2022 Tasuku Tozawa. All rights reserved.
//

import AppFeature
import Combine
import CompositeKit
import CoreDataCloudKitSupport
import Domain
import Environment
import PreviewContent
import SwiftUI
import TagMultiSelectionFeature
import TsundocCreateFeature

class DummyContainer: ObservableObject {
    let cloudKitAvailabilityObserver: CloudKitAvailabilityObservable
    let tsundocQueryService: TsundocQueryService
    let tagQueryService: TagQueryService
    let tsundocCommandService: TsundocCommandService
    let tagCommandService: TagCommandService
    let userSettingStorage: UserSettingStorage

    init() {
        let cloudKitAvailabilityObserverMock = CloudKitAvailabilityObservableMock()
        cloudKitAvailabilityObserverMock.availability = CurrentValueSubject(nil).eraseToAnyPublisher()
        cloudKitAvailabilityObserverMock.fetchAvailabilityHandler = { return .unavailable }
        cloudKitAvailabilityObserver = cloudKitAvailabilityObserverMock

        let dummyTsundocs: [Tsundoc] = [
            .makeDefault(title: NSLocalizedString("tsundoc.0.title", comment: ""),
                         url: URL(string: "http://www.example.com")!,
                         emojiAlias: "rice_ball",
                         emojiBackgroundColor: .default,
                         isUnread: false),
            .makeDefault(title: NSLocalizedString("tsundoc.1.title", comment: ""),
                         url: URL(string: "http://www.example.com")!,
                         emojiAlias: "bird",
                         emojiBackgroundColor: .blue,
                         isUnread: true),
            .makeDefault(title: NSLocalizedString("tsundoc.2.title", comment: ""),
                         url: URL(string: "http://www.example.com")!,
                         emojiAlias: "sunglasses",
                         emojiBackgroundColor: .green,
                         isUnread: true),
        ]

        let dummyTags: [Tag] = [
            .makeDefault(name: NSLocalizedString("tag.0.name", comment: ""), tsundocsCount: 2),
            .makeDefault(name: NSLocalizedString("tag.1.name", comment: ""), tsundocsCount: 1),
            .makeDefault(name: NSLocalizedString("tag.2.name", comment: ""), tsundocsCount: 1),
        ]

        let tsundocQueryServiceMock = TsundocQueryServiceMock()
        tsundocQueryServiceMock.queryTsundocHandler = { _ in
            .success(ObservedTsundocMock(value: .init(dummyTsundocs[0])).eraseToAnyObservedEntity())
        }
        tsundocQueryServiceMock.queryTsundocsHandler = { _ in
            .success(ObservedTsundocArrayMock(values: .init(dummyTsundocs)).eraseToAnyObservedEntityArray())
        }
        tsundocQueryServiceMock.queryAllTsundocsHandler = {
            .success(ObservedTsundocArrayMock(values: .init(dummyTsundocs)).eraseToAnyObservedEntityArray())
        }
        tsundocQueryService = tsundocQueryServiceMock

        let tagQueryServiceMock = TagQueryServiceMock()
        tagQueryServiceMock.fetchTagsHandler = { _ in
            .success(Set(dummyTags))
        }
        tagQueryServiceMock.queryTagHandler = { _ in
            .success(ObservedTagMock(value: .init(dummyTags[0])).eraseToAnyObservedEntity())
        }
        tagQueryServiceMock.queryTagsHandler = { _ in
            .success(ObservedTagArrayMock(values: .init(Array(dummyTags.prefix(2)))).eraseToAnyObservedEntityArray())
        }
        tagQueryServiceMock.queryAllTagsHandler = {
            .success(ObservedTagArrayMock(values: .init(dummyTags)).eraseToAnyObservedEntityArray())
        }
        tagQueryService = tagQueryServiceMock

        tsundocCommandService = TsundocCommandServiceMock()
        tagCommandService = TagCommandServiceMock()

        let userSettingStorageMock = UserSettingStorageMock()
        userSettingStorageMock.isiCloudSyncEnabled = CurrentValueSubject(false).eraseToAnyPublisher()
        userSettingStorageMock.isiCloudSyncEnabledValue = false
        userSettingStorage = userSettingStorageMock
    }
}

extension DummyContainer: HasPasteboard {
    public var pasteboard: Pasteboard { UIPasteboard.general }
}

extension DummyContainer: HasTsundocQueryService {}
extension DummyContainer: HasTagQueryService {}
extension DummyContainer: HasTsundocCommandService {}
extension DummyContainer: HasTagCommandService {}
extension DummyContainer: HasUserSettingStorage {}
extension DummyContainer: HasCloudKitAvailabilityObserver {}
extension DummyContainer: HasNop {}

extension DummyContainer: TsundocListBuildable {
    func buildTsundocList(title: String, emptyTile: String, emptyMessage: String?, isTsundocCreationEnabled: Bool, query: TsundocListQuery) -> AnyView {
        let store = Store(initialState: TsundocListState(query: .all),
                          dependency: self,
                          reducer: TsundocListReducer())
        return AnyView(TsundocList(title: title,
                                   emptyTitle: emptyTile,
                                   emptyMessage: emptyMessage,
                                   isTsundocCreationEnabled: isTsundocCreationEnabled,
                                   store: ViewStore(store: store)))
    }
}

extension DummyContainer: TagListBuildable {
    func buildTagList() -> AnyView {
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

extension DummyContainer: TagMultiSelectionSheetBuildable {
    func buildTagMultiSelectionSheet(selectedIds: Set<Tag.ID>, onDone: @escaping ([Tag]) -> Void) -> AnyView {
        AnyView(EmptyView())
    }
}

extension DummyContainer: TsundocInfoViewBuildable {
    func buildTsundocInfoView(tsundoc: Tsundoc) -> AnyView {
        let store = Store(initialState: TsundocInfoViewState(tsundoc: tsundoc, tags: []),
                          dependency: self,
                          reducer: TsundocInfoViewReducer())
        return AnyView(TsundocInfoView(store: ViewStore(store: store)))
    }
}

extension DummyContainer: SettingViewBuilder {
    func buildSettingView() -> AnyView {
        AnyView(EmptyView())
    }
}

extension DummyContainer: TsundocCreateViewBuildable {
    func buildTsundocCreateView(url: URL, onDone: @escaping (Bool) -> Void) -> AnyView {
        AnyView(EmptyView())
    }
}
