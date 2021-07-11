//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import TsunDocsUIKit

public enum SharedUrlImageAction: Action {
    case onLoadImageUrl(URL?)
    case didTapSelectEmoji
    case didTapDeleteEmoji
    case selectedEmoji(Emoji?)
    case updatedThumbnail(AsyncImageStatus?)
    case updatedEmojiSheet(isPresenting: Bool)
}
