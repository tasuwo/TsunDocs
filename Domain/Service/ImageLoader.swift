//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import Foundation
import UIKit

public class ImageLoader: ObservableObject {
    public enum Complete {
        case image(UIImage)
        case failure
        case cancelled

        init(_ image: UIImage?) {
            if let image = image {
                self = .image(image)
            } else {
                self = .failure
            }
        }
    }

    // MARK: - Properties

    private let urlSession: URLSession
    private var cancellable: AnyCancellable?

    @Published public var complete: Complete?

    // MARK: - Initializers

    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    deinit {
        cancel()
    }

    // MARK: - Methods

    public func load(_ url: URL) {
        cancellable?.cancel()
        cancellable = urlSession.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .map { Complete($0) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] complete in
                switch complete {
                case .failure:
                    self?.complete = .failure

                case .finished:
                    break
                }
            } receiveValue: { [weak self] complete in
                self?.complete = complete
            }
    }

    func cancel() {
        cancellable?.cancel()
        if complete == nil {
            complete = .cancelled
        }
    }
}
