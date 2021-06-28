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

public struct AsyncImage<Placeholder: View>: View {
    // MARK: - Properties

    @StateObject private var loader: ImageLoader

    private let url: URL
    private let placeholder: Placeholder

    // MARK: - Initializers

    public init(url: URL,
                factory: Factory<ImageLoader> = .default,
                @ViewBuilder placeholder: () -> Placeholder)
    {
        self.url = url
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
                    .overlay(
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 16, height: 16, alignment: .center)
                            .foregroundColor(.gray.opacity(0.7))
                    )

            case .none:
                placeholder
                    .overlay(ProgressView())
            }
        }
        .onAppear(perform: {
            loader.load(url)
        })
    }
}

// MARK: - Preview

struct AsyncImage_Previews: PreviewProvider {
    class SuccessMock: URLProtocolMockBase {
        override class var mock_delay: TimeInterval? { 3 }
        override class var mock_handler: ((URLRequest) throws -> (HTTPURLResponse, Data?))? {
            #if os(iOS)
            // swiftlint:disable:next force_unwrapping
            return { _ in (.mock_success, UIImage(named: "320x320")!.pngData()) }
            #elseif os(macOS)
            // swiftlint:disable:next force_unwrapping
            return { _ in (.mock_success, NSImage(named: "320x320")!.tiffRepresentation) }
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
                               factory: .init { .init(urlSession: .makeMock(SuccessMock.self)) },
                               placeholder: { Color.gray.opacity(0.5) })
                        .frame(width: 100, height: 100, alignment: .center)

                    // swiftlint:disable:next force_unwrapping
                    AsyncImage(url: URL(string: "https://localhost")!,
                               factory: .init { .init(urlSession: .makeMock(FailureMock.self)) },
                               placeholder: { Color.gray.opacity(0.5) })
                        .frame(width: 100, height: 100, alignment: .center)
                }
                HStack {
                    // swiftlint:disable:next force_unwrapping
                    AsyncImage(url: URL(string: "https://localhost")!,
                               factory: .init { .init(urlSession: .makeMock(SuccessMock.self)) },
                               placeholder: { Color.green.opacity(0.5) })
                        .frame(width: 100, height: 100, alignment: .center)

                    // swiftlint:disable:next force_unwrapping
                    AsyncImage(url: URL(string: "https://localhost")!,
                               factory: .init { .init(urlSession: .makeMock(FailureMock.self)) },
                               placeholder: { Color.green.opacity(0.5) })
                        .frame(width: 100, height: 100, alignment: .center)
                }
            }
        }
    }
}
