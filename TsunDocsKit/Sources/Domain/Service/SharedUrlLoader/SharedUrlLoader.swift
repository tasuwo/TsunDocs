//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import Foundation

/// @mockable
public protocol URLLoadable {
    func load(_ completion: @escaping (URL?) -> Void)
}

public class SharedUrlLoader {
    // MARK: - Properties

    private let context: NSExtensionContext
    private var cancellable: AnyCancellable?

    // MARK: - Initializers

    public init(_ context: NSExtensionContext) {
        self.context = context
    }

    deinit {
        cancellable?.cancel()
    }
}

extension SharedUrlLoader: URLLoadable {
    // MARK: - URLLoadable

    public func load(_ completion: @escaping (URL?) -> Void) {
        cancellable = context
            .resolveUrls { urls in
                completion(urls.first)
            }
    }
}
