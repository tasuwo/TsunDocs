//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import EmojiList
import SwiftUI
import TagKit

public struct TsundocEditView: View {
    // MARK: - Properties

    private let url: URL
    private let imageUrl: URL?
    private let onTapSaveButton: () -> Void

    @Binding private var title: String
    @Binding private var selectedEmoji: Emoji?
    @Binding private var selectedTags: [Tag]

    @State private var isTagEditSheetPresenting = false

    // MARK: - Initializers

    public init(url: URL,
                imageUrl: URL?,
                title: Binding<String>,
                selectedEmoji: Binding<Emoji?>,
                selectedTags: Binding<[Tag]>,
                onTapSaveButton: @escaping () -> Void)
    {
        self.url = url
        self.imageUrl = imageUrl
        _title = title
        _selectedEmoji = selectedEmoji
        _selectedTags = selectedTags
        self.onTapSaveButton = onTapSaveButton
    }

    // MARK: - View

    public var body: some View {
        VStack {
            TsundocMetaContainer(url: url, imageUrl: imageUrl, title: $title, selectedEmoji: $selectedEmoji)

            Divider()

            tagContainer()

            Divider()

            Spacer()

            Button {
                onTapSaveButton()
            } label: {
                HStack {
                    Image(systemName: "checkmark")
                    Text("tsundoc_edit_view_save_button", bundle: Bundle.module)
                }
            }
            // TODO:
            // .buttonStyle(PrimaryButtonStyle())
            .padding()
        }
        .padding(8)
        .sheet(isPresented: $isTagEditSheetPresenting) {
            // TODO:
            TagMultiSelectionView(tags: .init(get: { [] }, set: { _ in })) { _ in
                isTagEditSheetPresenting = false
                // selectedTags = $0
            }
        }
    }

    @ViewBuilder
    func tagContainer() -> some View {
        VStack {
            HStack {
                Text("tsundoc_edit_view_tags_title", bundle: Bundle.module)

                Spacer()

                Image(systemName: "plus")
                    .foregroundColor(.cyan)
                    .font(.system(size: 24))
                    .onTapGesture {
                        isTagEditSheetPresenting = true
                    }
            }

            if !selectedTags.isEmpty {
                TagGrid(tags: selectedTags, selectedIds: .init(), inset: 0)
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
        @State private var selectedEmoji: Emoji? = nil
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
                                selectedEmoji: $selectedEmoji,
                                selectedTags: $selectedTags) {
                    isPresenting = false
                }
            }
        }
    }

    static var previews: some View {
        ContentView()
    }
}
