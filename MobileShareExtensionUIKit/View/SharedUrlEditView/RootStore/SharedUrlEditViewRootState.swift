//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import TsunDocsUIKit

struct SharedUrlEditViewRootState: Equatable {
    var editViewState: SharedUrlEditViewState {
        get {
            .init(sharedUrl: sharedUrl,
                  sharedUrlTitle: sharedUrlTitle,
                  sharedUrlDescription: sharedUrlDescription,
                  sharedUrlImageUrl: sharedUrlImageUrl,
                  selectedEmoji: selectedEmoji,
                  alert: alert)
        }
        set {
            sharedUrl = newValue.sharedUrl
            sharedUrlTitle = newValue.sharedUrlTitle
            sharedUrlDescription = newValue.sharedUrlDescription
            sharedUrlImageUrl = newValue.sharedUrlImageUrl
            selectedEmoji = newValue.selectedEmoji
            alert = newValue.alert
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

    // MARK: - Shared

    var sharedUrlImageUrl: URL?
    var selectedEmoji: Emoji?

    // MARK: - SharedUrlEditViewState

    var sharedUrl: URL?
    var sharedUrlTitle: String?
    var sharedUrlDescription: String?
    var alert: SharedUrlEditViewState.Alert?

    // MARK: - SharedUrlImageState

    var thumbnailLoadingStatus: AsyncImageStatus?
    var isSelectingEmoji: Bool
}

extension SharedUrlEditViewRootState {
    init() {
        isSelectingEmoji = false
    }
}

extension SharedUrlEditViewRootState {
    static let mappingToEdit: StateMapping<Self, SharedUrlEditViewState> = .init(keyPath: \Self.editViewState)
    static let mappingToImage: StateMapping<Self, SharedUrlImageState> = .init(keyPath: \Self.imageState)
}
