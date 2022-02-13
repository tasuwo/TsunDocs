//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import ButtonStyle
import struct Domain.Emoji
import struct Domain.Tag
import EmojiList
import SwiftUI
import TagKit

public struct TsundocEditView: View {
    // MARK: - Properties

    private let url: URL
    private let imageUrl: URL?
    private let onTapSaveButton: () -> Void

    @Binding private var title: String
    @Binding private var selectedEmojiInfo: EmojiInfo?
    @Binding private var selectedTags: [Tag]

    @State private var isTagEditSheetPresenting = false

    @Environment(\.tagControlViewStoreBuilder) private var builder: TagControlViewStoreBuildable

    // MARK: - Initializers

    public init(url: URL,
                imageUrl: URL?,
                title: Binding<String>,
                selectedEmojiInfo: Binding<EmojiInfo?>,
                selectedTags: Binding<[Tag]>,
                onTapSaveButton: @escaping () -> Void)
    {
        self.url = url
        self.imageUrl = imageUrl
        _title = title
        _selectedEmojiInfo = selectedEmojiInfo
        _selectedTags = selectedTags
        self.onTapSaveButton = onTapSaveButton
    }

    // MARK: - View

    @MainActor
    public var body: some View {
        VStack {
            TsundocMetaContainer(url: url, imageUrl: imageUrl, title: $title, selectedEmojiInfo: $selectedEmojiInfo)

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
            .padding()
        }
        .padding(8)
        .sheet(isPresented: $isTagEditSheetPresenting) {
            TagMultiSelectionSheet(selectedIds: Set(selectedTags.map(\.id)),
                                   viewStore: builder.buildTagControlViewStore()) {
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
                    .foregroundColor(.cyan)
                    .font(.system(size: 24))
                    .onTapGesture {
                        isTagEditSheetPresenting = true
                    }
            }

            if !selectedTags.isEmpty {
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

// MARK: - Preview

struct TsundocEditView_Previews: PreviewProvider {
    struct ContentView: View {
        @State private var title: String = "My Title"
        @State private var selectedEmojiInfo: EmojiInfo? = nil
        @State private var selectedTags: [Tag] = []
        @State private var isPresenting = false

        init() {}

        var body: some View {
            Button {
                isPresenting = true
            } label: {
                Text("Press me")
            }
            .sheet(isPresented: $isPresenting) {
                TsundocEditView(url: URL(string: "https://localhost")!,
                                imageUrl: nil,
                                title: $title,
                                selectedEmojiInfo: $selectedEmojiInfo,
                                selectedTags: $selectedTags) {
                    isPresenting = false
                }
                .environment(\.tagControlViewStoreBuilder, TagControlViewStoreBuilderMock())
            }
        }
    }

    static var previews: some View {
        ContentView()
    }
}
