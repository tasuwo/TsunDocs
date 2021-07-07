//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public struct WebPageMeta {
    public let title: String?
    public let description: String?
    public let imageUrl: URL?

    // MARK: - Initializers

    public init(title: String?,
                description: String?,
                imageUrl: URL?)
    {
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
    }
}
