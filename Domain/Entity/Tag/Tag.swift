//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

// sourcery: AutoDefaultValue
public struct Tag: Searchable, Equatable {
    // MARK: - Properties

    public let id: UUID
    public let name: String
    public let tsundocsCount: Int

    // MARK: - Searchable

    public let searchableText: String?

    // MARK: - Initializers

    public init(id: UUID, name: String, tsundocsCount: Int, searchableText: String?) {
        self.id = id
        self.name = name
        self.searchableText = searchableText
        self.tsundocsCount = tsundocsCount
    }

    public init(id: UUID, name: String, tsundocsCount: Int) {
        self.id = id
        self.name = name
        self.searchableText = name.transformToSearchableText()
        self.tsundocsCount = tsundocsCount
    }
}

extension Tag: Identifiable {}

extension Tag: Hashable {}
