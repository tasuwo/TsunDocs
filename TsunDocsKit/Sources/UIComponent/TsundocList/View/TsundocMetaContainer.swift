//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Emoji
import SwiftUI

public struct TsundocMetaContainer: View {
    // MARK: - Properties

    private let url: URL
    private let imageUrl: URL?
    private let isPreparing: Bool

    @Binding var title: String
    @Binding var selectedEmojiInfo: EmojiInfo?

    @State var isTitleEditAlertPresenting = false

    // MARK: - Initializers

    public init(url: URL,
                imageUrl: URL?,
                isPreparing: Bool,
                title: Binding<String>,
                selectedEmojiInfo: Binding<EmojiInfo?>)
    {
        self.url = url
        self.imageUrl = imageUrl
        self.isPreparing = isPreparing
        _title = title
        _selectedEmojiInfo = selectedEmojiInfo
    }

    // MARK: - View

    public var body: some View {
        HStack(alignment: .top) {
            VStack {
                TsundocEditThumbnail(imageUrl: imageUrl,
                                     isPreparing: isPreparing,
                                     selectedEmojiInfo: $selectedEmojiInfo)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if isPreparing {
                        Text("tsundoc_edit_view_preparing_title", bundle: Bundle.this)
                            .foregroundColor(.gray)
                            .font(.body)
                    } else if !title.isEmpty {
                        Text(title)
                            .lineLimit(4)
                            .font(.body)
                    } else {
                        Text("tsundoc_edit_view_no_title", bundle: Bundle.this)
                            .foregroundColor(.gray)
                            .font(.body)
                    }

                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(isPreparing ? .gray.opacity(0.6) : .accentColor)
                        .font(.system(size: 24))
                }
                .onTapGesture {
                    isTitleEditAlertPresenting = true
                }
                .allowsHitTesting(!isPreparing)

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
               config: .init(title: NSLocalizedString("tsundoc_edit_view_title_edit_title", bundle: Bundle.this, comment: ""),
                             message: NSLocalizedString("tsundoc_edit_view_title_edit_message", bundle: Bundle.this, comment: ""),
                             placeholder: NSLocalizedString("tsundoc_edit_view_title_edit_placeholder", bundle: Bundle.this, comment: ""),
                             validator: { title != $0 && $0?.count ?? 0 > 0 },
                             saveAction: { title = $0 },
                             cancelAction: nil))
    }
}

#if DEBUG

// MARK: - Preview

struct TsundocMetaContainer_Previews: PreviewProvider {
    struct Container: View {
        let url: URL
        let imageUrl: URL?
        @State var title: String
        @State var selectedEmojiInfo: EmojiInfo?
        @State var isPreparing: Bool = false

        var body: some View {
            VStack {
                TsundocMetaContainer(url: url,
                                     imageUrl: imageUrl,
                                     isPreparing: isPreparing,
                                     title: $title,
                                     selectedEmojiInfo: $selectedEmojiInfo)

                Toggle(isOn: $isPreparing) {
                    Text("isPreparing")
                }
            }
        }
    }

    static var previews: some View {
        VStack {
            Divider()

            // swiftlint:disable:next force_unwrapping
            Container(url: URL(string: "https://apple.com")!,
                      // swiftlint:disable:next force_unwrapping
                      imageUrl: URL(string: "https://localhost")!,
                      title: "My Title")

            Divider()

            // swiftlint:disable:next force_unwrapping
            Container(url: URL(string: "https://apple.com")!,
                      imageUrl: nil,
                      title: "")

            Divider()

            // swiftlint:disable:next force_unwrapping
            Container(url: URL(string: "https://apple.com")!,
                      // swiftlint:disable:next force_unwrapping
                      imageUrl: URL(string: "https://localhost/\(String(repeating: "long/", count: 100))")!,
                      title: String(repeating: "Title ", count: 100))

            Divider()
        }
    }
}

#endif
