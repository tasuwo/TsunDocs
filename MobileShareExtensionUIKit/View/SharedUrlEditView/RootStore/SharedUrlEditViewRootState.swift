//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import TsunDocsUIKit

public struct SharedUrlEditViewRootState: Equatable {
    var editViewState: SharedUrlEditViewState {
        get {
            .init(sharedUrl: sharedUrl,
                  sharedUrlTitle: sharedUrlTitle,
                  sharedUrlDescription: sharedUrlDescription,
                  sharedUrlImageUrl: sharedUrlImageUrl,
                  selectedEmoji: selectedEmoji,
                  selectedTags: selectedTags,
                  alert: alert,
                  isTitleEditAlertPresenting: isTitleEditAlertPresenting,
                  isTagEditSheetPresenting: isTagEditSheetPresenting)
        }
        set {
            sharedUrl = newValue.sharedUrl
            sharedUrlTitle = newValue.sharedUrlTitle
            sharedUrlDescription = newValue.sharedUrlDescription
            sharedUrlImageUrl = newValue.sharedUrlImageUrl
            selectedEmoji = newValue.selectedEmoji
            selectedTags = newValue.selectedTags
            alert = newValue.alert
            isTitleEditAlertPresenting = newValue.isTitleEditAlertPresenting
            isTagEditSheetPresenting = newValue.isTagEditSheetPresenting
        }
    }

    var imageState: SharedUrlImageState {
        get {
            .init(imageUrl: sharedUrlImageUrl,
                  thumbnailLoadingStatus: thumbnailLoadingStatus,
                  selectedEmoji: selectedEmoji,
                  isSelectingEmoji: isSelectingEmoji)
        }
        set {
            sharedUrlImageUrl = newValue.imageUrl
            thumbnailLoadingStatus = newValue.thumbnailLoadingStatus
            selectedEmoji = newValue.selectedEmoji
            isSelectingEmoji = newValue.isSelectingEmoji
        }
    }

    var tagGridState: TagGridState {
        get {
            .init(tags: selectedTags,
                  configuration: .init(.deletable))
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // NOP
        }
    }

    // MARK: - Shared

    var sharedUrlImageUrl: URL?
    var selectedEmoji: Emoji?

    // MARK: - SharedUrlEditViewState

    var sharedUrl: URL?
    var sharedUrlTitle: String?
    var sharedUrlDescription: String?
    var selectedTags: [Tag]
    var alert: SharedUrlEditViewState.Alert?
    var isAlertPresenting: Bool { alert != nil }
    var isTitleEditAlertPresenting: Bool
    var isTagEditSheetPresenting: Bool

    // MARK: - SharedUrlImageState

    var thumbnailLoadingStatus: AsyncImageStatus?
    var isSelectingEmoji: Bool
}

public extension SharedUrlEditViewRootState {
    init() {
        selectedTags = []
        isTitleEditAlertPresenting = false
        isTagEditSheetPresenting = false
        isSelectingEmoji = false
    }
}

public extension SharedUrlEditViewRootState {
    static let mappingToEdit: StateMapping<Self, SharedUrlEditViewState> = .init(keyPath: \Self.editViewState)
    static let mappingToImage: StateMapping<Self, SharedUrlImageState> = .init(keyPath: \Self.imageState)
    static let mappingToTagGrid: StateMapping<Self, TagGridState> = .init(keyPath: \Self.tagGridState)
}
