//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import NukeUI
import SwiftUI
import UIComponent

struct TsundocThumbnail: View {
    // MARK: - Properties

    let source: TsundocThumbnailSource?

    // MARK: - View

    @MainActor
    private var content: some View {
        Group {
            switch source {
            case let .imageUrl(url):
                LazyImage(url: url) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if state.error != nil {
                        ZStack {
                            Color.gray.opacity(0.4)

                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 16, height: 16, alignment: .center)
                                .foregroundColor(.gray.opacity(0.7))
                        }
                    } else {
                        Color.gray.opacity(0.4)
                    }
                }

            case let .emoji(emoji: emoji, backgroundColor: backgroundColor):
                backgroundColor.swiftUIColor
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

struct TsundocThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                HStack {
                    TsundocThumbnail(source: nil)

                    TsundocThumbnail(source: .emoji(emoji: "👍", backgroundColor: .white))
                }

                HStack {
                    // swiftlint:disable:next force_unwrapping
                    TsundocThumbnail(source: .imageUrl(URL(string: "https://localhost")!))

                    // swiftlint:disable:next force_unwrapping
                    TsundocThumbnail(source: .imageUrl(URL(string: "https://localhost")!))
                }
            }
        }
    }
}

#endif
