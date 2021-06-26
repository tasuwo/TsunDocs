//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import Foundation

class SharedUrlLoader: ObservableObject {
    // MARK: - Properties

    private let context: NSExtensionContext
    private var cancellable: AnyCancellable?

    @Published var url: URL?

    // MARK: - Initializers

    init(_ context: NSExtensionContext) {
        self.context = context
    }

    deinit {
        cancellable?.cancel()
    }

    // MARK: - Methods

    func load() {
        cancellable = context
            .resolveUrls { [weak self] in
                self?.url = $0.first
            }
    }
}
