//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import Foundation

class SharedUrlLoader: ObservableObject {
    // MARK: - Properties

    private let context: NSExtensionContext
    private var cancellable: AnyCancellable?

    // MARK: - Initializers

    init(_ context: NSExtensionContext) {
        self.context = context
    }

    deinit {
        cancellable?.cancel()
    }

    // MARK: - Methods

    func load(_ completion: @escaping (URL?) -> Void) {
        cancellable = context
            .resolveUrls { urls in
                completion(urls.first)
            }
    }
}
