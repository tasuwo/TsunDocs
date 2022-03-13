//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public enum AsyncImageStatus: Equatable {
    case empty
    case loaded(Image)
    case failed
    case cancelled
}

public struct AsyncImage<Content>: View where Content: View {
    public enum ContentMode {
        case fit
        case fill
    }

    // MARK: - Properties

    @StateObject private var loader: ImageLoader

    private let url: URL
    private let content: (ImageLoader.Complete?) -> Content

    // MARK: - Initializers

    public init<C, P>(url: URL,
                      size: CGSize? = nil,
                      contentMode: ContentMode = .fit,
                      factory: Factory<ImageLoader> = .default,
                      @ViewBuilder content: @escaping (Image) -> C,
                      @ViewBuilder placeholder: @escaping () -> P) where C: View, P: View, Content == _ConditionalContent<C, P>
    {
        self.url = url
        self.content = { complete in
            switch complete {
            case let .image(image):
                #if os(iOS)
                let thumbnail: UIImage
                if let size = size {
                    let target = Self.calcSize(for: image, size: size, contentMode: contentMode)
                    thumbnail = image.preparingThumbnail(of: target) ?? image
                } else {
                    thumbnail = image
                }
                return ViewBuilder.buildEither(first: content(Image(uiImage: thumbnail)))
                #elseif os(macOS)
                return ViewBuilder.buildEither(first: content(Image(nsImage: image)))
                #endif

            case .failure, .cancelled:
                return ViewBuilder.buildEither(second: placeholder())

            case .none:
                return ViewBuilder.buildEither(second: placeholder())
            }
        }

        _loader = StateObject(wrappedValue: factory.make())
    }

    public init(url: URL,
                size: CGSize? = nil,
                contentMode: ContentMode = .fit,
                factory: Factory<ImageLoader> = .default,
                @ViewBuilder content: @escaping (AsyncImageStatus) -> Content)
    {
        self.url = url
        self.content = { complete in
            switch complete {
            case let .image(image):
                #if os(iOS)
                let thumbnail: UIImage
                if let size = size {
                    let target = Self.calcSize(for: image, size: size, contentMode: contentMode)
                    thumbnail = image.preparingThumbnail(of: target) ?? image
                } else {
                    thumbnail = image
                }
                return content(.loaded(Image(uiImage: thumbnail)))
                #elseif os(macOS)
                return content(.loaded(Image(nsImage: image)))
                #endif

            case .failure:
                return content(.failed)

            case .cancelled:
                return content(.cancelled)

            case .none:
                return content(.empty)
            }
        }

        _loader = StateObject(wrappedValue: factory.make())
    }

    // MARK: - View

    public var body: some View {
        content(loader.complete)
            .onAppear {
                loader.load(url)
            }
    }

    // MARK: - Methods

    static func calcSize(for image: UIImage, size: CGSize, contentMode: ContentMode) -> CGSize {
        switch contentMode {
        case .fit:
            return image.size.aspectFit(to: size)

        case .fill:
            return image.size.aspectFill(to: size)
        }
    }
}

// MARK: - Preview

#if DEBUG

struct AsyncImage_Previews: PreviewProvider {
    class SuccessMock: URLProtocolMockBase {
        override class var mock_delay: TimeInterval? { 3 }
        override class var mock_handler: ((URLRequest) throws -> (HTTPURLResponse, Data?))? {
            #if os(iOS)
            // swiftlint:disable:next force_unwrapping
            return { _ in (.mock_success, UIImage(named: "320x320", in: Bundle.this, with: nil)!.pngData()) }
            #elseif os(macOS)
            // swiftlint:disable:next force_unwrapping
            return { _ in (.mock_success, Bundle.this.image(forResource: "320x320")!.tiffRepresentation) }
            #endif
        }
    }

    class FailureMock: URLProtocolMockBase {
        override class var mock_delay: TimeInterval? { 3 }
        override class var mock_handler: ((URLRequest) throws -> (HTTPURLResponse, Data?))? {
            return { _ in (.mock_failure, nil) }
        }
    }

    static var previews: some View {
        Group {
            VStack {
                HStack {
                    // swiftlint:disable:next force_unwrapping
                    AsyncImage(url: URL(string: "https://localhost")!,
                               factory: .init { .init(urlSession: .makeMock(SuccessMock.self)) }) {
                        $0.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.5)
                    }
                    .frame(width: 100, height: 100, alignment: .center)

                    // swiftlint:disable:next force_unwrapping
                    AsyncImage(url: URL(string: "https://localhost")!,
                               factory: .init { .init(urlSession: .makeMock(FailureMock.self)) }) {
                        $0.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.5)
                    }
                    .frame(width: 100, height: 100, alignment: .center)
                }
                HStack {
                    // swiftlint:disable:next force_unwrapping
                    AsyncImage(url: URL(string: "https://localhost")!,
                               factory: .init { .init(urlSession: .makeMock(SuccessMock.self)) }) {
                        switch $0 {
                        case .empty:
                            Color.gray.opacity(0.5)
                                .overlay(ProgressView())

                        case let .loaded(image):
                            image
                                .resizable()

                        case .cancelled, .failed:
                            Color.gray.opacity(0.5)
                        }
                    }
                    .frame(width: 100, height: 100, alignment: .center)

                    // swiftlint:disable:next force_unwrapping
                    AsyncImage(url: URL(string: "https://localhost")!,
                               factory: .init { .init(urlSession: .makeMock(FailureMock.self)) }) {
                        switch $0 {
                        case .empty:
                            Color.gray.opacity(0.5)
                                .overlay(ProgressView())

                        case let .loaded(image):
                            image
                                .resizable()

                        case .cancelled, .failed:
                            Color.gray.opacity(0.5)
                                .overlay(Image(systemName: "xmark"))
                        }
                    }
                    .frame(width: 100, height: 100, alignment: .center)
                }
            }
        }
    }
}

#endif
