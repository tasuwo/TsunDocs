//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation
import Smile

// sourcery: AutoDefaultValue
public struct Tsundoc {
    // MARK: - Properties

    public let id: UUID
    public let title: String
    public let description: String?
    public let url: URL
    public let imageUrl: URL?
    public let emojiAlias: String?
    public let updatedDate: Date
    public let createdDate: Date

    // MARK: - Initializers

    public init(id: UUID,
                title: String,
                description: String?,
                url: URL,
                imageUrl: URL?,
                emojiAlias: String?,
                updatedDate: Date,
                createdDate: Date)
    {
        self.id = id
        self.title = title
        self.description = description
        self.url = url
        self.imageUrl = imageUrl
        self.emojiAlias = emojiAlias
        self.updatedDate = updatedDate
        self.createdDate = createdDate
    }
}

public extension Tsundoc {
    var thumbnailSource: TsundocThumbnailSource? {
        if let emojiAlias = emojiAlias,
           Smile.isEmoji(character: Smile.replaceAlias(string: ":\(emojiAlias):"))
        {
            return .emoji(Smile.replaceAlias(string: ":\(emojiAlias):"))
        } else if let imageUrl = imageUrl {
            return .imageUrl(imageUrl)
        } else {
            return nil
        }
    }
}

extension Tsundoc: Identifiable {}

extension Tsundoc: Equatable {}
