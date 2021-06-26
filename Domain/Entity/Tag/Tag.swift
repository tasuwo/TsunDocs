//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

// sourcery: AutoDefaultValue
public struct Tag {
    // MARK: - Properties

    public let id: UUID
    public let name: String

    // MARK: - Initializers

    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

extension Tag: Identifiable {}

extension Tag: Hashable {}
