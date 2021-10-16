//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

public struct Tag: Equatable, Identifiable, Hashable {
    // MARK: - Properties

    public let id: UUID
    public var name: String
    public var count: Int

    // MARK: - Initializers

    public init(id: UUID, name: String, count: Int = 0) {
        self.id = id
        self.name = name
        self.count = count
    }
}
