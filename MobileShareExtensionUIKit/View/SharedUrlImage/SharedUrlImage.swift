//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI
import TsunDocsUIKit

struct SharedUrlImage: View {
    // MARK: - Properties

    private let thumbnailSize: CGFloat = 80
    private let imageLoaderFactory: Factory<ImageLoader>

    @StateObject var store: ViewStore<SharedUrlImageState, SharedUrlImageAction, SharedUrlImageDependency>

    // MARK: - Initializers

    init(store: ViewStore<SharedUrlImageState, SharedUrlImageAction, SharedUrlImageDependency>,
         imageLoaderFactory: Factory<ImageLoader> = .default)
    {
        self._store = StateObject(wrappedValue: store)
        self.imageLoaderFactory = imageLoaderFactory
    }

    // MARK: - View

    private var thumbnail: some View {
        Group {
            if let emoji = store.state.selectedEmoji {
                Color.green.opacity(0.4)
                    .overlay(
                        Text(emoji.emoji)
                            .font(.system(size: 32))
                    )
                    .onTapGesture {
                        store.execute(.didTapSelectEmoji)
                    }
            } else {
                if let imageUrl = store.state.imageUrl {
                    ZStack {
                        AsyncImage(url: imageUrl,
                                   status: store.bind(\.thumbnailLoadingStatus, action: { .updatedThumbnail($0) }),
                                   factory: imageLoaderFactory) {
                            Color.gray.opacity(0.4)
                        }
                        .aspectRatio(contentMode: .fill)

                        if store.state.thumbnailLoadingStatus == .failed
                            || store.state.thumbnailLoadingStatus == .cancelled
                        {
                            Image(systemName: "xmark")
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
                        .onTapGesture {
                            store.execute(.didTapSelectEmoji)
                        }
                }
            }
        }
        .sheet(isPresented: store.bind(\.isSelectingEmoji, action: { .updatedEmojiSheet(isPresenting: $0) })) {
            NavigationView {
                EmojiList(selectedEmoji: store.bind(\.selectedEmoji, action: { .selectedEmoji($0) }))
            }
        }
    }

    var body: some View {
        ZStack {
            thumbnail
                .frame(width: thumbnailSize, height: thumbnailSize, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            if store.state.visibleDeleteButton {
                Image(systemName: "xmark")
                    .font(.system(size: 14).bold())
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25)
                    .background(Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 25 / 2, style: .continuous))
                    .offset(x: -1 * (thumbnailSize / 2) + 5,
                            y: -1 * (thumbnailSize / 2) + 5)
                    .onTapGesture {
                        store.execute(.didTapDeleteEmoji)
                    }
            }

            if store.state.visibleEmojiLoadButton {
                Image(systemName: "face.smiling")
                    .font(.system(size: 14).bold())
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 25 / 2, style: .continuous))
                    .offset(x: (thumbnailSize / 2) - 6,
                            y: (thumbnailSize / 2) - 6)
                    .onTapGesture {
                        store.execute(.didTapSelectEmoji)
                    }
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
        class Nop: HasNop {}

        let imageUrl: URL?
        let imageLoaderFactory: Factory<ImageLoader>

        var body: some View {
            let store = Store(initialState: SharedUrlImageState(imageUrl: imageUrl),
                              dependency: Nop(),
                              reducer: SharedUrlImageReducer())
            let viewStore = ViewStore(store: store)

            SharedUrlImage(store: viewStore, imageLoaderFactory: imageLoaderFactory)
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
