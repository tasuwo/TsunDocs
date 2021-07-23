//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

public struct TsundocEditThumbnail: View {
    public typealias Store = ViewStore<
        TsundocEditThumbnailState,
        TsundocEditThumbnailAction,
        TsundocEditThumbnailDependency
    >

    // MARK: - Properties

    public static let thumbnailSize: CGFloat = 88
    public static let badgeSize: CGFloat = 32
    public static let badgeSymbolSize: CGFloat = 18
    public static let padding: CGFloat = 32 / 2 - 6

    @StateObject var store: Store
    @State var isSelectingEmoji = false

    @Environment(\.imageLoaderFactory) var imageLoaderFactory

    // MARK: - Initializers

    public init(store: Store) {
        _store = StateObject(wrappedValue: store)
    }

    // MARK: - View

    private var thumbnail: some View {
        ZStack {
            if let emoji = store.state.selectedEmoji {
                Color("emoji_background", bundle: Bundle.tsunDocsUiKit)
                    .overlay(
                        Text(emoji.emoji)
                            .font(.system(size: 40))
                    )
                    .onTapGesture {
                        isSelectingEmoji = true
                    }
            } else {
                if let imageUrl = store.state.imageUrl {
                    ZStack {
                        AsyncImage(url: imageUrl,
                                   status: store.bind(\.thumbnailLoadingStatus,
                                                      action: { .updatedThumbnail($0) }),
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
                            isSelectingEmoji = true
                        }
                }
            }
        }
        .sheet(isPresented: $isSelectingEmoji) {
            NavigationView {
                EmojiList {
                    isSelectingEmoji = false
                    store.execute(.selectedEmoji($0), animation: .default)
                }
            }
        }
    }

    // MARK: - View

    public var body: some View {
        ZStack {
            thumbnail
                .frame(width: Self.thumbnailSize, height: Self.thumbnailSize, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.all, Self.padding)

            if store.state.visibleDeleteButton {
                makeBadge(systemName: "xmark", backgroundColor: .gray)
                    .offset(x: -1 * (Self.thumbnailSize / 2) + 5,
                            y: -1 * (Self.thumbnailSize / 2) + 5)
                    .onTapGesture {
                        store.execute(.didTapDeleteEmoji)
                    }
            }

            if store.state.visibleEmojiLoadButton {
                makeBadge(systemName: "face.smiling", backgroundColor: .cyan)
                    .offset(x: (Self.thumbnailSize / 2) - 6,
                            y: (Self.thumbnailSize / 2) - 6)
                    .onTapGesture {
                        isSelectingEmoji = true
                    }
            } else if !store.state.visibleDeleteButton {
                makeBadge(systemName: "plus", backgroundColor: .cyan)
                    .offset(x: (Self.thumbnailSize / 2) - 6,
                            y: (Self.thumbnailSize / 2) - 6)
                    .onTapGesture {
                        isSelectingEmoji = true
                    }
            }
        }
    }

    // MARK: - Methods

    private func makeBadge(systemName: String, backgroundColor: Color) -> some View {
        Image(systemName: systemName)
            .font(.system(size: Self.badgeSymbolSize).bold())
            .foregroundColor(Color(uiColor: UIColor.systemBackground))
            .frame(width: Self.badgeSize, height: Self.badgeSize)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Self.badgeSize / 2, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Self.badgeSize / 2, style: .continuous)
                    .stroke(Color(uiColor: UIColor.systemBackground), lineWidth: 3)
            )
    }
}

// MARK: - Preview

@MainActor
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
            let store = Store(initialState: TsundocEditThumbnailState(imageUrl: imageUrl),
                              dependency: Nop(),
                              reducer: TsundocEditThumbnailReducer())
            let viewStore = ViewStore(store: store)

            TsundocEditThumbnail(store: viewStore)
                .environment(\.imageLoaderFactory, imageLoaderFactory)
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
