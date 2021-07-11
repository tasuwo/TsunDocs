//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Smile

public struct Emoji: Searchable {
    public let alias: String
    public let emoji: String

    // MARK: - Searchable

    public let searchableText: String?

    // MARK: - Initializers

    public init(alias: String,
                emoji: String,
                searchableText: String?)
    {
        self.alias = alias
        self.emoji = emoji
        self.searchableText = searchableText
    }
}

public extension Emoji {
    static func emojiList() -> [Emoji] {
        Smile.emojiList
            .sorted(by: <)
            .map {
                Emoji(alias: $0.key,
                      emoji: $0.value,
                      searchableText: $0.key.transformToSearchableText()!)
            }
    }
}

extension Emoji: Identifiable {
    // MARK: - Identifiable

    public var id: String { alias }
}
