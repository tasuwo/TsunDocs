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

    public init?(alias: String) {
        self.alias = alias

        let maybeEmoji = Smile.replaceAlias(string: ":\(alias):")
        guard Smile.isEmoji(character: maybeEmoji) else {
            return nil
        }

        self.emoji = maybeEmoji
        self.searchableText = alias.transformToSearchableText()
    }
}

public extension Emoji {
    static func emojiList() -> [Emoji] {
        Smile.emojiList
            .sorted(by: <)
            .map {
                Emoji(alias: $0.key,
                      emoji: $0.value,
                      // swiftlint:disable:next force_unwrapping
                      searchableText: $0.key.transformToSearchableText()!)
            }
    }
}

extension Emoji: Identifiable {
    // MARK: - Identifiable

    public var id: String { alias }
}
