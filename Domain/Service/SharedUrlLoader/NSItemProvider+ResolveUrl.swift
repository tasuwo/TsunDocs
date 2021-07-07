//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import UniformTypeIdentifiers

extension NSItemProvider {
    func resolveUrl() -> Future<URL?, Never> {
        return Future { promise in
            self.resolveUrl { promise(.success($0)) }
        }
    }

    private func resolveUrl(_ completion: @escaping (URL?) -> Void) {
        if hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { item, _ in
                guard let url = item as? URL else {
                    completion(nil)
                    return
                }
                completion(url)
            }
            return
        }

        completion(nil)
    }
}
