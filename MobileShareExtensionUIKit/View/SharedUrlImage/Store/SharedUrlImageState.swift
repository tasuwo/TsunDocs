//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import TsunDocsUIKit

public struct SharedUrlImageState: Equatable {
    var imageUrl: URL?
    var thumbnailLoadingStatus: AsyncImageStatus?
    var selectedEmoji: Emoji?
    var isSelectingEmoji: Bool
}

public extension SharedUrlImageState {
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
        self.thumbnailLoadingStatus = nil
        self.selectedEmoji = nil
        self.isSelectingEmoji = false
    }
}

extension SharedUrlImageState {
    var visibleDeleteButton: Bool { selectedEmoji != nil }
    var visibleEmojiLoadButton: Bool { imageUrl != nil && selectedEmoji == nil }
}
