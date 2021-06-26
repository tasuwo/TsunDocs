//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import Kanna

class SharedUrlMetaResolver {
    struct SharedUrlMeta {
        let title: String?
        let description: String?
        let imageUrl: URL?
    }

    func resolve(from url: URL) throws -> SharedUrlMeta {
        let doc = try Kanna.HTML(url: url, encoding: .utf8)

        return SharedUrlMeta(title: doc.title,
                             description: resolveDescription(doc: doc),
                             imageUrl: resolveOgpImageUrl(doc: doc))
    }

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
