//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import SwiftUI
import TsunDocsUIKit

struct TsundocThumbnail: View {
    // MARK: - Properties

    @State private var status: AsyncImageStatus?

    private let source: TsundocThumbnailSource?
    private let imageLoaderFactory: Factory<ImageLoader>

    // MARK: - Initializers

    init(source: TsundocThumbnailSource?,
         imageLoaderFactory: Factory<ImageLoader> = .default)
    {
        self.source = source
        self.imageLoaderFactory = imageLoaderFactory
    }

    // MARK: - View

    private var content: some View {
        Group {
            switch source {
            case let .imageUrl(url):
                ZStack {
                    AsyncImage(url: url, status: $status, factory: imageLoaderFactory) {
                        Color.gray.opacity(0.4)
                    }
                    .aspectRatio(contentMode: .fill)

                    if status == .failed || status == .cancelled {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 16, height: 16, alignment: .center)
                            .foregroundColor(.gray.opacity(0.7))
                    }
                }

            case let .emoji(emoji):
                Color.cyan
                    .overlay(
                        Text(emoji)
                            .font(.system(size: 40))
                    )

            case .none:
                Color.gray.opacity(0.4)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 16))
                            .foregroundColor(Color.gray)
                    )
            }
        }
    }

    var body: some View {
        content
            .frame(width: 80, height: 80, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Preview

struct TsundocThumbnailView_Previews: PreviewProvider {
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
                    TsundocThumbnail(source: nil,
                                     imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocThumbnail(source: .emoji("👍"),
                                     imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })
                }

                HStack {
                    // swiftlint:disable:next force_unwrapping
                    TsundocThumbnail(source: .imageUrl(URL(string: "https://localhost")!),
                                     imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    // swiftlint:disable:next force_unwrapping
                    TsundocThumbnail(source: .imageUrl(URL(string: "https://localhost")!),
                                     imageLoaderFactory: .init { .init(urlSession: .makeMock(FailureMock.self)) })
                }
            }
        }
    }
}
