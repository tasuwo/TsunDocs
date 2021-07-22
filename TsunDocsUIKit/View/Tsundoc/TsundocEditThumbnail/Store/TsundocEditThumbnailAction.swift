//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public enum TsundocEditThumbnailAction: Action {
    case onLoadImageUrl(URL?)
    case didTapSelectEmoji
    case didTapDeleteEmoji
    case selectedEmoji(Emoji?)
    case updatedThumbnail(AsyncImageStatus?)
    case updatedEmojiSheet(isPresenting: Bool)
}
