//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Emoji
import enum Domain.EmojiBackgroundColor
import NukeUI
import SwiftUI

public struct TsundocEditThumbnail: View {
    // MARK: - Properties

    public static let thumbnailSize: CGFloat = 88
    public static let padding: CGFloat = 32 / 2 - 6

    private let imageUrl: URL?
    private let isPreparing: Bool

    @Binding private var selectedEmojiInfo: EmojiInfo?

    @State private var isSelectingEmoji = false

    private var visibleDeleteButton: Bool { selectedEmojiInfo != nil }
    private var visibleEmojiLoadButton: Bool { imageUrl != nil && selectedEmojiInfo == nil }

    // MARK: - Initializers

    public init(imageUrl: URL?,
                isPreparing: Bool,
                selectedEmojiInfo: Binding<EmojiInfo?>)
    {
        self.imageUrl = imageUrl
        self.isPreparing = isPreparing
        _selectedEmojiInfo = selectedEmojiInfo
    }

    // MARK: - View

    @MainActor
    private var thumbnail: some View {
        ZStack {
            if isPreparing {
                Color.gray.opacity(0.4)
                    .overlay(ProgressView())
            } else if let emojiInfo = selectedEmojiInfo {
                Button {
                    isSelectingEmoji = true
                } label: {
                    Text(emojiInfo.emoji.emoji)
                        .font(.system(size: 40))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(emojiInfo.backgroundColor.swiftUIColor)
            } else {
                if let imageUrl = imageUrl {
                    let request = ImageRequest(url: imageUrl, userInfo: [.thumbnailKey: ImageRequest.ThumbnailOptions(size: CGSize(width: Self.thumbnailSize, height: Self.thumbnailSize))])
                    LazyImage(request: request) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if state.error != nil {
                            ZStack {
                                Color.gray.opacity(0.4)

                                Image(systemName: "xmark")
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                        } else {
                            Color.gray.opacity(0.4)
                        }
                    }
                } else {
                    Button {
                        isSelectingEmoji = true
                    } label: {
                        Image(systemName: "face.dashed")
                            .font(.system(size: 24))
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.gray.opacity(0.4))
                    }
                }
            }
        }
        .sheet(isPresented: $isSelectingEmoji) {
            NavigationView {
                EmojiList(currentEmoji: selectedEmojiInfo?.emoji,
                          backgroundColors: EmojiBackgroundColor.self)
                { emoji, backgrounColor in
                    isSelectingEmoji = false
                    selectedEmojiInfo = .init(emoji: emoji, backgroundColor: backgrounColor)
                } onCancel: {
                    isSelectingEmoji = false
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
                Badge(image: Image(systemName: "xmark"), backgroundColor: .gray) {
                    selectedEmojiInfo = nil
                }
                .offset(x: -1 * (Self.thumbnailSize / 2) + 5,
                        y: -1 * (Self.thumbnailSize / 2) + 5)
                .disabled(isPreparing)
            }

            if visibleEmojiLoadButton {
                Badge(image: Image(systemName: "face.smiling")) {
                    isSelectingEmoji = true
                }
                .offset(x: (Self.thumbnailSize / 2) - 6,
                        y: (Self.thumbnailSize / 2) - 6)
                .disabled(isPreparing)
            } else if !visibleDeleteButton {
                Badge(image: Image(systemName: "plus")) {
                    isSelectingEmoji = true
                }
                .offset(x: (Self.thumbnailSize / 2) - 6,
                        y: (Self.thumbnailSize / 2) - 6)
                .disabled(isPreparing)
            }
        }
    }
}

#if DEBUG

// MARK: - Preview

struct SharedUrlThumbnailView_Previews: PreviewProvider {
    struct Container: View {
        @State var isPreparing: Bool = false
        @State var selectedEmojiInfo: EmojiInfo?

        let imageUrl: URL?

        var body: some View {
            HStack {
                TsundocEditThumbnail(imageUrl: imageUrl,
                                     isPreparing: isPreparing,
                                     selectedEmojiInfo: $selectedEmojiInfo)
                VStack {
                    Toggle(isOn: $isPreparing) {
                        Text("isPreparing")
                    }
                }
            }
        }
    }

    static var previews: some View {
        Group {
            VStack {
                Container(imageUrl: nil)

                // swiftlint:disable:next force_unwrapping
                Container(imageUrl: URL(string: "https://localhost")!)

                // swiftlint:disable:next force_unwrapping
                Container(imageUrl: URL(string: "https://localhost")!)
            }
        }
    }
}

#endif
