//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
import Nuke

public class ImageLoader: ObservableObject {
    public enum Complete: Equatable {
        #if os(iOS)
        case image(UIImage)
        #elseif os(macOS)
        case image(NSImage)
        #endif
        case failure
        case cancelled
    }

    // MARK: - Properties

    public var complete: Complete? {
        guard !isCancelled else {
            return .cancelled
        }

        switch image.result {
        case let .success(response):
            return .image(response.container.image)

        case .failure:
            return .failure

        case .none:
            return nil
        }
    }

    private let image = FetchImage()
    private var isCancelled = false
    private var cancellable: Set<AnyCancellable> = .init()

    // MARK: - Initializers

    public init(urlSession: URLSession = .shared) {
        let urlConfiguration = urlSession.configuration
        urlConfiguration.urlCache = DataLoader.sharedUrlCache

        let dataLoader = DataLoader(configuration: urlConfiguration, validate: DataLoader.validate(response:))
        var configuration = ImagePipeline.Configuration.withURLCache
        configuration.dataLoader = dataLoader
        image.pipeline = .init(configuration: configuration, delegate: nil)

        image.objectWillChange
            .sink { [weak self] in
                self?.objectWillChange.send()
            }
            .store(in: &cancellable)
    }

    deinit {
        cancel()
    }

    // MARK: - Methods

    public func load(_ url: URL) {
        image.load(url)
    }

    func cancel() {
        image.cancel()
        cancellable.removeAll()
        if complete == nil {
            isCancelled = true
        }
    }
}
