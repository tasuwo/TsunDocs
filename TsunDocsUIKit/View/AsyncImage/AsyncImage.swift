//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public enum AsyncImageStatus: Equatable {
    case loaded
    case failed
    case cancelled
}

public struct AsyncImage<Placeholder: View>: View {
    // MARK: - Properties

    @StateObject private var loader: ImageLoader
    @Binding private var status: AsyncImageStatus?

    private let url: URL
    private let placeholder: Placeholder

    // MARK: - Initializers

    public init(url: URL,
                status: Binding<AsyncImageStatus?>,
                factory: Factory<ImageLoader> = .default,
                @ViewBuilder placeholder: () -> Placeholder)
    {
        self.url = url
        self._status = status
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: factory.make())
    }

    // MARK: - View

    public var body: some View {
        Group {
            switch loader.complete {
            case let .image(image):
                #if os(iOS)
                Image(uiImage: image)
                    .resizable()
                #elseif os(macOS)
                Image(nsImage: image)
                    .resizable()
                #endif

            case .failure, .cancelled:
                placeholder

            case .none:
                placeholder
                    .overlay(ProgressView())
            }
        }
        .onAppear {
            loader.load(url)
        }
        .onChange(of: loader.complete) {
            status = $0?.asyncImageStatus
        }
    }
}

private extension ImageLoader.Complete {
    var asyncImageStatus: AsyncImageStatus {
        switch self {
        case .image:
            return .loaded

        case .cancelled:
            return .cancelled

        case .failure:
            return .failed
        }
    }
}

// MARK: - Preview

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
                               status: .constant(nil),
                               factory: .init { .init(urlSession: .makeMock(SuccessMock.self)) },
                               placeholder: { Color.gray.opacity(0.5) })
                        .frame(width: 100, height: 100, alignment: .center)

                    // swiftlint:disable:next force_unwrapping
                    AsyncImage(url: URL(string: "https://localhost")!,
                               status: .constant(nil),
                               factory: .init { .init(urlSession: .makeMock(FailureMock.self)) },
                               placeholder: { Color.gray.opacity(0.5) })
                        .frame(width: 100, height: 100, alignment: .center)
                }
                HStack {
                    // swiftlint:disable:next force_unwrapping
                    AsyncImage(url: URL(string: "https://localhost")!,
                               status: .constant(nil),
                               factory: .init { .init(urlSession: .makeMock(SuccessMock.self)) },
                               placeholder: { Color.green.opacity(0.5) })
                        .frame(width: 100, height: 100, alignment: .center)

                    // swiftlint:disable:next force_unwrapping
                    AsyncImage(url: URL(string: "https://localhost")!,
                               status: .constant(nil),
                               factory: .init { .init(urlSession: .makeMock(FailureMock.self)) },
                               placeholder: { Color.green.opacity(0.5) })
                        .frame(width: 100, height: 100, alignment: .center)
                }
            }
        }
    }
}
