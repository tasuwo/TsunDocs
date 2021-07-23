//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

public struct TsundocEditThumbnailState: Equatable {
    public var imageUrl: URL?
    public var thumbnailLoadingStatus: AsyncImageStatus?
    public var selectedEmoji: Emoji?

    public init(imageUrl: URL?,
                thumbnailLoadingStatus: AsyncImageStatus?,
                selectedEmoji: Emoji?)
    {
        self.imageUrl = imageUrl
        self.thumbnailLoadingStatus = thumbnailLoadingStatus
        self.selectedEmoji = selectedEmoji
    }
}

public extension TsundocEditThumbnailState {
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
        self.thumbnailLoadingStatus = nil
        self.selectedEmoji = nil
    }
}

extension TsundocEditThumbnailState {
    var visibleDeleteButton: Bool { selectedEmoji != nil }
    var visibleEmojiLoadButton: Bool { imageUrl != nil && selectedEmoji == nil }
}
