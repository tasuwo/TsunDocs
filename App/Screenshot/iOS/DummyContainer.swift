//
//  Copyright © 2022 Tasuku Tozawa. All rights reserved.
//

import Combine
import Domain
import Environment
import Foundation
import MobileSettingFeature
import PreviewContent
import UIKit

class DummyContainer: ObservableObject {
    let cloudKitAvailabilityObserver: CloudKitAvailabilityObservable
    let tsundocQueryService: TsundocQueryService
    let tagQueryService: TagQueryService
    let tsundocCommandService: TsundocCommandService
    let tagCommandService: TagCommandService
    let userSettingStorage: UserSettingStorage
    let webPageMetaResolver: WebPageMetaResolvable
    let sharedUserSettingStorage: SharedUserSettingStorage

    init() {
        let cloudKitAvailabilityObserverMock = CloudKitAvailabilityObservableMock()
        cloudKitAvailabilityObserverMock.cloudKitAccountAvailability = CurrentValueSubject(nil).eraseToAnyPublisher()
        cloudKitAvailabilityObserverMock.isCloudKitAccountAvaialbe = nil
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

        let webPageMetaResolverMock = WebPageMetaResolvableMock()
        webPageMetaResolver = webPageMetaResolverMock

        let sharedUserSettingStorageMock = SharedUserSettingStorageMock()
        sharedUserSettingStorage = sharedUserSettingStorageMock
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
extension DummyContainer: HasWebPageMetaResolver {}
extension DummyContainer: HasNop {}
extension DummyContainer: HasSharedUserSettingStorage {}
