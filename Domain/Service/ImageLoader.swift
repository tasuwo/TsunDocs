//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import Foundation
#if os(iOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

public class ImageLoader: ObservableObject {
    public enum Complete {
        #if os(iOS)
            case image(UIImage)
        #elseif os(macOS)
            case image(NSImage)
        #endif
        case failure
        case cancelled

        init(_ data: Data?) {
            if let data = data {
                #if os(iOS)
                    if let image = UIImage(data: data) {
                        self = .image(image)
                    } else {
                        self = .failure
                    }
                #elseif os(macOS)
                    if let image = NSImage(data: data) {
                        self = .image(image)
                    } else {
                        self = .failure
                    }
                #endif
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
            .map { Complete($0.data) }
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
