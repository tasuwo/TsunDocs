//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import SwiftUI
import TsunDocsUIKit

struct TsundocThumbnail: View {
    // MARK: - Properties

    @Environment(\.imageLoaderFactory) var imageLoaderFactory

    let source: TsundocThumbnailSource?

    // MARK: - View

    private var content: some View {
        Group {
            switch source {
            case let .imageUrl(url):
                AsyncImage(url: url,
                           size: .init(width: 80 * 2,
                                       height: 80 * 2),
                           contentMode: .fill,
                           factory: imageLoaderFactory) {
                    switch $0 {
                    case let .loaded(image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)

                    case .failed, .cancelled:
                        ZStack {
                            Color.gray.opacity(0.4)

                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 16, height: 16, alignment: .center)
                                .foregroundColor(.gray.opacity(0.7))
                        }

                    case .empty:
                        Color.gray.opacity(0.4)
                            .overlay(ProgressView())
                    }
                }

            case let .emoji(emoji):
                Color("emoji_background", bundle: Bundle.tsunDocsUiKit)
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

#if DEBUG
import PreviewContent
#endif

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
                    TsundocThumbnail(source: nil)
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocThumbnail(source: .emoji("👍"))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(SuccessMock.self)) })
                }

                HStack {
                    // swiftlint:disable:next force_unwrapping
                    TsundocThumbnail(source: .imageUrl(URL(string: "https://localhost")!))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    // swiftlint:disable:next force_unwrapping
                    TsundocThumbnail(source: .imageUrl(URL(string: "https://localhost")!))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(FailureMock.self)) })
                }
            }
        }
    }
}
