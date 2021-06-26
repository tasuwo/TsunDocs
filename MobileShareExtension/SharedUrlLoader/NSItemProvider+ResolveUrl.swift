//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import Foundation
import MobileCoreServices

extension NSItemProvider {
    func resolveUrl() -> Future<URL?, Never> {
        return Future { promise in
            self.resolveUrl { promise(.success($0)) }
        }
    }

    private func resolveUrl(_ completion: @escaping (URL?) -> Void) {
        if hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
            loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { item, _ in
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
