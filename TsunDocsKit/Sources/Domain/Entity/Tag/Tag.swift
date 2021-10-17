//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation
import SearchKit

// sourcery: AutoDefaultValuePublic
public struct Tag: Searchable, Equatable {
    // MARK: - Properties

    public let id: UUID
    public var name: String
    public var tsundocsCount: Int

    public var count: Int { tsundocsCount }

    // MARK: - Searchable

    public let searchableText: String?

    // MARK: - Initializers

    public init(id: UUID, name: String, tsundocsCount: Int, searchableText: String?) {
        self.id = id
        self.name = name
        self.searchableText = searchableText
        self.tsundocsCount = tsundocsCount
    }

    public init(id: UUID, name: String, tsundocsCount: Int = 0) {
        self.id = id
        self.name = name
        self.searchableText = name.transformToSearchableText()
        self.tsundocsCount = tsundocsCount
    }
}

extension Tag: Identifiable {}

extension Tag: Hashable {}
