//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Emoji
import struct Domain.Tag
import SwiftUI

public struct TsundocEditView<TagMultiSelectionSheet: View>: View {
    // MARK: - Properties

    private let url: URL
    private let imageUrl: URL?
    private let isPreparing: Bool
    private let onTapSaveButton: () -> Void
    private let tagMultiSelectionSheetBuilder: (Set<Tag.ID>, @escaping ([Tag]) -> Void) -> TagMultiSelectionSheet

    @Binding private var title: String
    @Binding private var selectedEmojiInfo: EmojiInfo?
    @Binding private var selectedTags: [Tag]
    @Binding private var isUnread: Bool

    @State private var isTagEditSheetPresenting = false

    // MARK: - Initializers

    public init(url: URL,
                imageUrl: URL?,
                isPreparing: Bool,
                title: Binding<String>,
                selectedEmojiInfo: Binding<EmojiInfo?>,
                selectedTags: Binding<[Tag]>,
                isUnread: Binding<Bool>,
                onTapSaveButton: @escaping () -> Void,
                tagMultiSelectionSheetBuilder: @escaping (Set<Tag.ID>, @escaping ([Tag]) -> Void) -> TagMultiSelectionSheet)
    {
        self.url = url
        self.imageUrl = imageUrl
        self.isPreparing = isPreparing
        _title = title
        _selectedEmojiInfo = selectedEmojiInfo
        _selectedTags = selectedTags
        _isUnread = isUnread
        self.onTapSaveButton = onTapSaveButton
        self.tagMultiSelectionSheetBuilder = tagMultiSelectionSheetBuilder
    }

    // MARK: - View

    @MainActor
    public var body: some View {
        VStack {
            TsundocMetaContainer(url: url,
                                 imageUrl: imageUrl,
                                 isPreparing: isPreparing,
                                 title: $title,
                                 selectedEmojiInfo: $selectedEmojiInfo)

            Divider()

            HStack {
                Toggle(isOn: $isUnread) {
                    Text("tsundoc_edit_view_unread_toggle", bundle: Bundle.this)
                }
                .toggleStyle(.switch)
                .disabled(isPreparing)
            }
            .padding([.leading, .trailing], TsundocEditThumbnail.padding)

            Divider()

            tagContainer()

            Divider()

            Spacer()

            Button {
                onTapSaveButton()
            } label: {
                HStack {
                    Image(systemName: "checkmark")
                    Text("tsundoc_edit_view_save_button", bundle: Bundle.this)
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(isPreparing)
            .padding()
        }
        .padding(8)
        .sheet(isPresented: $isTagEditSheetPresenting) {
            self.tagMultiSelectionSheetBuilder(Set(selectedTags.map(\.id))) {
                isTagEditSheetPresenting = false
                selectedTags = $0
            }
        }
    }

    @ViewBuilder
    func tagContainer() -> some View {
        VStack {
            HStack {
                Text("tsundoc_edit_view_tags_title", bundle: Bundle.this)

                Spacer()

                Image(systemName: "plus")
                    .foregroundColor(isPreparing ? .gray.opacity(0.6) : .accentColor)
                    .font(.body.weight(.bold))
                    .onTapGesture {
                        isTagEditSheetPresenting = true
                    }
                    .allowsHitTesting(!isPreparing)
            }

            if !selectedTags.isEmpty, !isPreparing {
                TagGrid(tags: selectedTags, selectedIds: .init(), configuration: .init(.deletable), inset: 0) { action in
                    switch action {
                    case let .delete(tagId: tagId):
                        withAnimation {
                            guard let index = selectedTags.firstIndex(where: { $0.id == tagId }) else { return }
                            selectedTags.remove(at: index)
                        }

                    default:
                        // NOP
                        break
                    }
                }
            } else {
                Spacer()
            }
        }
        .padding([.leading, .trailing], TsundocEditThumbnail.padding)
    }
}

#if DEBUG

// MARK: - Preview

struct TsundocEditView_Previews: PreviewProvider {
    struct ContentView: View {
        @State private var isPreparing: Bool = false
        @State private var title: String = "My Title"
        @State private var selectedEmojiInfo: EmojiInfo? = nil
        @State private var selectedTags: [Tag] = []
        @State private var isUnread: Bool = false

        init() {}

        var body: some View {
            VStack {
                TsundocEditView(url: URL(string: "https://localhost")!,
                                imageUrl: nil,
                                isPreparing: isPreparing,
                                title: $title,
                                selectedEmojiInfo: $selectedEmojiInfo,
                                selectedTags: $selectedTags,
                                isUnread: $isUnread)
                {
                    // NOP
                } tagMultiSelectionSheetBuilder: { _, _ in
                    EmptyView()
                }

                Divider()

                Toggle(isOn: $isPreparing) {
                    Text("isPreparing")
                }
            }
        }
    }

    static var previews: some View {
        ContentView()
    }
}

#endif
