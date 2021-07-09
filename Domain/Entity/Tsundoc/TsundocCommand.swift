//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

// sourcery: AutoDefaultValue
public struct TsundocCommand {
    // MARK: - Properties

    public let title: String
    public let description: String?
    public let url: URL
    public let imageUrl: URL?
    public let emojiAlias: String?

    // MARK: - Initializers

    public init(title: String,
                description: String?,
                url: URL,
                imageUrl: URL?,
                emojiAlias: String?)
    {
        self.title = title
        self.description = description
        self.url = url
        self.imageUrl = imageUrl
        self.emojiAlias = emojiAlias
    }
}
