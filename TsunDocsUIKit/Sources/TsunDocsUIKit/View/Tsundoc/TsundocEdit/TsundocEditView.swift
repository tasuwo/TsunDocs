//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

public struct TsundocEditView: View {
    // MARK: - Properties

    private let url: URL
    private let imageUrl: URL?
    private let onTapSaveButton: () -> Void

    @Binding private var title: String
    @Binding private var selectedEmoji: Emoji?
    @Binding private var selectedTags: [Tag]

    @State private var isTagEditSheetPresenting = false

    @Environment(\.tagGridStoreBuilder) var tagGridStoreBuilder
    @Environment(\.tagMultiAdditionViewStoreBuilder) var tagMultiAdditionViewStoreBuilder

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

    @MainActor
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
                    Text(L10n.tsundocEditViewSaveButton)
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding()
        }
        .padding(8)
        .sheet(isPresented: $isTagEditSheetPresenting) {
            let viewStore = tagMultiAdditionViewStoreBuilder.buildTagMultiAdditionViewStore(selectedIds: Set(selectedTags.map(\.id)))
            TagMultiAdditionView(store: viewStore) {
                isTagEditSheetPresenting = false
                selectedTags = $0
            }
        }
    }

    @MainActor
    @ViewBuilder
    func tagContainer() -> some View {
        VStack {
            HStack {
                Text(L10n.tsundocEditViewTagsTitle)

                Spacer()

                Image(systemName: "plus")
                    .foregroundColor(.cyan)
                    .font(.system(size: 24))
                    .onTapGesture {
                        isTagEditSheetPresenting = true
                    }
            }

            if !selectedTags.isEmpty {
                TagGrid(store: tagGridStoreBuilder.buildTagGridStore(), inset: 0)
            } else {
                Spacer()
            }
        }
        .padding([.leading, .trailing], TsundocEditThumbnail.padding)
    }
}

// MARK: - Preview

@MainActor
struct TsundocEditView_Previews: PreviewProvider {
    static var previews: some View {
        // TODO:
        EmptyView()
    }
}
