//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine

extension NSExtensionContext {
    func resolveUrls(_ completion: @escaping ([URL]) -> Void) -> AnyCancellable? {
        let items = inputItems.compactMap { $0 as? NSExtensionItem }
        guard !items.isEmpty else {
            completion([])
            return nil
        }

        let futures = items
            .compactMap(\.attachments)
            .flatMap { $0 }
            .map { $0.resolveUrl().compactMap { $0 } }

        return Publishers.MergeMany(futures)
            .collect()
            .sink { completion($0) }
    }
}
