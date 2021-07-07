//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Kanna

/// @mockable
public protocol WebPageMetaResolvable {
    func resolve(from url: URL) throws -> WebPageMeta
}

public struct WebPageMetaResolver {
    // MARK: - Initializers

    public init() {}

    // MARK: - Methods

    private func resolveDescription(doc: HTMLDocument) -> String? {
        for path in doc.xpath("//meta[@name='description']") {
            if let string = path["content"] {
                return string
            }
        }
        return nil
    }

    private func resolveOgpImageUrl(doc: HTMLDocument) -> URL? {
        for path in doc.xpath("//meta[@property='og:image:secure_url']") {
            if let urlString = path["content"], let url = URL(string: urlString) {
                return url
            }
        }

        for path in doc.xpath("//meta[@property='og:image:url']") {
            if let urlString = path["content"], let url = URL(string: urlString) {
                return url
            }
        }

        for path in doc.xpath("//meta[@property='og:image']") {
            if let urlString = path["content"], let url = URL(string: urlString) {
                return url
            }
        }

        return nil
    }
}

extension WebPageMetaResolver: WebPageMetaResolvable {
    // MARK: - WebPageMetaResolvable

    public func resolve(from url: URL) throws -> WebPageMeta {
        let doc = try Kanna.HTML(url: url, encoding: .utf8)

        return WebPageMeta(title: doc.title,
                           description: resolveDescription(doc: doc),
                           imageUrl: resolveOgpImageUrl(doc: doc))
    }
}
