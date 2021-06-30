//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import SwiftUI
import TsunDocsUIKit

struct SharedUrlThumbnail: View {
    // MARK: - Properties

    private let thumbnailSize: CGFloat = 80

    private let imageUrl: URL?
    private let imageLoaderFactory: Factory<ImageLoader>

    @State private var thumbnailLoadingStatus: AsyncImageStatus?

    @Binding var visibleDeleteButton: Bool
    @Binding var emoji: String?

    // MARK: - Initializers

    init(imageUrl: URL?,
         visibleDeleteButton: Binding<Bool>,
         emoji: Binding<String?>,
         imageLoaderFactory: Factory<ImageLoader> = .default)
    {
        self.imageUrl = imageUrl
        self._visibleDeleteButton = visibleDeleteButton
        self._emoji = emoji
        self.imageLoaderFactory = imageLoaderFactory
    }

    // MARK: - View

    private var thumbnail: some View {
        Group {
            if let imageUrl = imageUrl {
                ZStack {
                    AsyncImage(url: imageUrl, status: $thumbnailLoadingStatus, factory: imageLoaderFactory) {
                        Color.gray.opacity(0.4)
                    }
                    .aspectRatio(contentMode: .fill)

                    if thumbnailLoadingStatus == .failed || thumbnailLoadingStatus == .cancelled {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 24))
                            .foregroundColor(.gray.opacity(0.7))
                    }
                }
            } else {
                Color.gray.opacity(0.4)
                    .overlay(
                        Image(systemName: "face.dashed")
                            .font(.system(size: 24))
                            .foregroundColor(Color.gray)
                    )
            }
        }
    }

    var body: some View {
        ZStack {
            thumbnail
                .frame(width: thumbnailSize, height: thumbnailSize, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            if visibleDeleteButton {
                Image(systemName: "xmark")
                    .font(.system(size: 12).bold())
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25)
                    .background(Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 25 / 2, style: .continuous))
                    .offset(x: -1 * (thumbnailSize / 2) + 5,
                            y: -1 * (thumbnailSize / 2) + 5)
            }
        }
    }
}

// MARK: - Preview

struct SharedUrlThumbnailView_Previews: PreviewProvider {
    class SuccessMock: URLProtocolMockBase {
        override class var mock_delay: TimeInterval? { 3 }
        override class var mock_handler: ((URLRequest) throws -> (HTTPURLResponse, Data?))? {
            // swiftlint:disable:next force_unwrapping
            return { _ in (.mock_success, UIImage(named: "320x320", in: Bundle.this, with: nil)!.pngData()) }
        }
    }

    class FailureMock: URLProtocolMockBase {
        override class var mock_delay: TimeInterval? { 3 }
        override class var mock_handler: ((URLRequest) throws -> (HTTPURLResponse, Data?))? {
            return { _ in (.mock_failure, nil) }
        }
    }

    struct Container: View {
        let imageUrl: URL?
        let imageLoaderFactory: Factory<ImageLoader>

        @State var visibleDeleteButton: Bool = false
        @State var emoji: String? = nil

        var body: some View {
            VStack {
                SharedUrlThumbnail(imageUrl: imageUrl,
                                   visibleDeleteButton: $visibleDeleteButton,
                                   emoji: $emoji,
                                   imageLoaderFactory: imageLoaderFactory)
                Button {
                    visibleDeleteButton = !visibleDeleteButton
                } label: {
                    Text("Toggle delete button")
                }
            }
        }
    }

    static var previews: some View {
        Group {
            VStack {
                Container(imageUrl: nil,
                          imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                // swiftlint:disable:next force_unwrapping
                Container(imageUrl: URL(string: "https://localhost")!,
                          imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                // swiftlint:disable:next force_unwrapping
                Container(imageUrl: URL(string: "https://localhost")!,
                          imageLoaderFactory: .init { .init(urlSession: .makeMock(FailureMock.self)) })
            }
        }
    }
}
