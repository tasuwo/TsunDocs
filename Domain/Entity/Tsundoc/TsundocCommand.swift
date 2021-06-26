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
    public let thumbnailSource: TsundocThumbnailSource?

    // MARK: - Initializers

    public init(title: String,
                description: String?,
                url: URL,
                thumbnailSource: TsundocThumbnailSource?)
    {
        self.title = title
        self.description = description
        self.url = url
        self.thumbnailSource = thumbnailSource
    }
}
