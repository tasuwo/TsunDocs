//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

public struct TsundocEditThumbnailState: Equatable {
    public var imageUrl: URL?
    public var thumbnailLoadingStatus: AsyncImageStatus?
    public var selectedEmoji: Emoji?
    public var isSelectingEmoji: Bool

    public init(imageUrl: URL?,
                thumbnailLoadingStatus: AsyncImageStatus?,
                selectedEmoji: Emoji?,
                isSelectingEmoji: Bool)
    {
        self.imageUrl = imageUrl
        self.thumbnailLoadingStatus = thumbnailLoadingStatus
        self.selectedEmoji = selectedEmoji
        self.isSelectingEmoji = isSelectingEmoji
    }
}

public extension TsundocEditThumbnailState {
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
        self.thumbnailLoadingStatus = nil
        self.selectedEmoji = nil
        self.isSelectingEmoji = false
    }
}

extension TsundocEditThumbnailState {
    var visibleDeleteButton: Bool { selectedEmoji != nil }
    var visibleEmojiLoadButton: Bool { imageUrl != nil && selectedEmoji == nil }
}
