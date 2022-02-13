//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Emoji
import enum Domain.EmojiBackgroundColor

public struct EmojiInfo {
    public let emoji: Emoji
    public let backgroundColor: EmojiBackgroundColor

    // MARK: - Initializers

    public init(emoji: Emoji, backgroundColor: EmojiBackgroundColor) {
        self.emoji = emoji
        self.backgroundColor = backgroundColor
    }
}
