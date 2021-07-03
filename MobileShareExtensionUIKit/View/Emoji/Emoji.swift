//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

public struct Emoji: Searchable {
    public let alias: String
    public let emoji: String

    // MARK: - Searchable

    public let searchableText: String?
}

extension Emoji: Identifiable {
    // MARK: - Identifiable

    public var id: String { alias }
}
