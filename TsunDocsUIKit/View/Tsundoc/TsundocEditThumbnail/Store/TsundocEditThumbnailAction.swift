//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public enum TsundocEditThumbnailAction: Action {
    case didTapDeleteEmoji
    case selectedEmoji(Emoji?)
    case updatedThumbnail(AsyncImageStatus?)
}
