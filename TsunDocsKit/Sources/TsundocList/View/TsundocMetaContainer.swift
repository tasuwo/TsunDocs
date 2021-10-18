//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Emoji
import EmojiList
import ImageLoader
import SwiftUI
import TextEditAlert

public struct TsundocMetaContainer: View {
    // MARK: - Properties

    private let url: URL
    private let imageUrl: URL?

    @Binding var title: String
    @Binding var selectedEmoji: Emoji?

    @State var isTitleEditAlertPresenting = false

    // MARK: - Initializers

    public init(url: URL,
                imageUrl: URL?,
                title: Binding<String>,
                selectedEmoji: Binding<Emoji?>)
    {
        self.url = url
        self.imageUrl = imageUrl
        _title = title
        _selectedEmoji = selectedEmoji
    }

    // MARK: - View

    public var body: some View {
        HStack(alignment: .top) {
            VStack {
                TsundocEditThumbnail(imageUrl: imageUrl, selectedEmoji: $selectedEmoji)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if !title.isEmpty {
                        Text(title)
                            .lineLimit(4)
                            .font(.body)
                    } else {
                        Text("tsundoc_edit_view_no_title", bundle: Bundle.module)
                            .foregroundColor(.gray)
                            .font(.title3)
                    }

                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.cyan)
                        .font(.system(size: 24))
                }
                .onTapGesture {
                    isTitleEditAlertPresenting = true
                }

                Text(url.absoluteString)
                    .lineLimit(2)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding([.top, .bottom], TsundocEditThumbnail.padding)

            Spacer()
        }
        .alert(isPresenting: $isTitleEditAlertPresenting,
               text: title,
               config: .init(title: NSLocalizedString("tsundoc_edit_view_title_edit_title", bundle: Bundle.module, comment: ""),
                             message: NSLocalizedString("tsundoc_edit_view_title_edit_message", bundle: Bundle.module, comment: ""),
                             placeholder: NSLocalizedString("tsundoc_edit_view_title_edit_placeholder", bundle: Bundle.module, comment: ""),
                             validator: { title != $0 && $0?.count ?? 0 > 0 },
                             saveAction: { title = $0 },
                             cancelAction: nil))
    }
}

// MARK: - Preview

struct TsundocMetaContainer_Previews: PreviewProvider {
    struct Container: View {
        let url: URL
        let imageUrl: URL?
        @State var title: String
        @State var selectedEmoji: Emoji?

        var body: some View {
            TsundocMetaContainer(url: url,
                                 imageUrl: imageUrl,
                                 title: $title,
                                 selectedEmoji: $selectedEmoji)
        }
    }

    static var previews: some View {
        let imageLoaderFactory = Factory<ImageLoader> {
            .init(urlSession: .makeMock(SuccessMock.self))
        }

        VStack {
            Divider()

            // swiftlint:disable:next force_unwrapping
            Container(url: URL(string: "https://apple.com")!,
                      // swiftlint:disable:next force_unwrapping
                      imageUrl: URL(string: "https://localhost")!,
                      title: "My Title")
                .environment(\.imageLoaderFactory, imageLoaderFactory)

            Divider()

            // swiftlint:disable:next force_unwrapping
            Container(url: URL(string: "https://apple.com")!,
                      imageUrl: nil,
                      title: "")
                .environment(\.imageLoaderFactory, imageLoaderFactory)

            Divider()

            // swiftlint:disable:next force_unwrapping
            Container(url: URL(string: "https://apple.com")!,
                      // swiftlint:disable:next force_unwrapping
                      imageUrl: URL(string: "https://localhost/\(String(repeating: "long/", count: 100))")!,
                      title: String(repeating: "Title ", count: 100))
                .environment(\.imageLoaderFactory, imageLoaderFactory)

            Divider()
        }
    }
}
