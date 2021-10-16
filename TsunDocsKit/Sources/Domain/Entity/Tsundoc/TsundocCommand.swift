//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

// sourcery: AutoDefaultValuePublic
public struct TsundocCommand {
    // MARK: - Properties

    public let title: String
    public let description: String?
    public let url: URL
    public let imageUrl: URL?
    public let emojiAlias: String?
    public let tagIds: [Tag.ID]

    // MARK: - Initializers

    public init(title: String,
                description: String?,
                url: URL,
                imageUrl: URL?,
                emojiAlias: String?,
                tagIds: [Tag.ID] = [])
    {
        self.title = title
        self.description = description
        self.url = url
        self.imageUrl = imageUrl
        self.emojiAlias = emojiAlias
        self.tagIds = tagIds
    }
}
