//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Emoji
import EmojiList
import ImageLoader
import SwiftUI

public struct TsundocEditThumbnail: View {
    // MARK: - Properties

    public static let thumbnailSize: CGFloat = 88
    public static let badgeSize: CGFloat = 32
    public static let badgeSymbolSize: CGFloat = 18
    public static let padding: CGFloat = 32 / 2 - 6

    private let imageUrl: URL?

    @Binding private var selectedEmoji: Emoji?

    @State private var isSelectingEmoji = false

    private var visibleDeleteButton: Bool { selectedEmoji != nil }
    private var visibleEmojiLoadButton: Bool { imageUrl != nil && selectedEmoji == nil }

    @Environment(\.imageLoaderFactory) var imageLoaderFactory

    // MARK: - Initializers

    public init(imageUrl: URL?, selectedEmoji: Binding<Emoji?>) {
        self.imageUrl = imageUrl
        _selectedEmoji = selectedEmoji
    }

    // MARK: - View

    private var thumbnail: some View {
        ZStack {
            if let emoji = selectedEmoji {
                Color.emojiBackground
                    .overlay(
                        Text(emoji.emoji)
                            .font(.system(size: 40))
                    )
                    .onTapGesture {
                        isSelectingEmoji = true
                    }
            } else {
                if let imageUrl = imageUrl {
                    AsyncImage(url: imageUrl,
                               size: .init(width: Self.thumbnailSize * 2,
                                           height: Self.thumbnailSize * 2),
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
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray.opacity(0.7))
                            }

                        case .empty:
                            Color.gray.opacity(0.4)
                                .overlay(ProgressView())
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
                EmojiList(backgroundColors: DefaultPickColor.self) { emoji, _ in
                    isSelectingEmoji = false
                    selectedEmoji = emoji
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

            if visibleDeleteButton {
                makeBadge(systemName: "xmark", backgroundColor: .gray)
                    .offset(x: -1 * (Self.thumbnailSize / 2) + 5,
                            y: -1 * (Self.thumbnailSize / 2) + 5)
                    .onTapGesture {
                        selectedEmoji = nil
                    }
            }

            if visibleEmojiLoadButton {
                makeBadge(systemName: "face.smiling", backgroundColor: .cyan)
                    .offset(x: (Self.thumbnailSize / 2) - 6,
                            y: (Self.thumbnailSize / 2) - 6)
                    .onTapGesture {
                        isSelectingEmoji = true
                    }
            } else if !visibleDeleteButton {
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
    struct Container: View {
        @State var selectedEmoji: Emoji?

        let imageUrl: URL?
        let imageLoaderFactory: Factory<ImageLoader>

        var body: some View {
            TsundocEditThumbnail(imageUrl: imageUrl, selectedEmoji: $selectedEmoji)
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
