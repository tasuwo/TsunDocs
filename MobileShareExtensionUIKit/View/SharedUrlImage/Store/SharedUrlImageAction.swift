//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import TsunDocsUIKit

public enum SharedUrlImageAction: Action {
    case didTapSelectEmoji
    case didTapDeleteEmoji
    case selectedEmoji(Emoji?)
    case updatedThumbnail(AsyncImageStatus?)
    case updatedEmojiSheet(isPresenting: Bool)
}
