//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

public struct TsundocEditView: View {
    // MARK: - Properties

    private let url: URL
    private let title: String
    private let selectedTags: Set<Tag.ID>
    private let onEditTitle: (String) -> Void
    private let onTapSaveButton: () -> Void
    private let onSelectTags: ([Tag]) -> Void

    @State var isTagEditSheetPresenting = false
    @State var isTitleEditAlertPresenting = false

    @Environment(\.tagGridStoreBuilder) var tagGridStoreBuilder
    @Environment(\.tagMultiAdditionViewStoreBuilder) var tagMultiAdditionViewStoreBuilder

    // MARK: - Initializers

    public init(url: URL,
                title: String,
                selectedTags: Set<Tag.ID>,
                onEditTitle: @escaping (String) -> Void,
                onTapSaveButton: @escaping () -> Void,
                onSelectTags: @escaping ([Tag]) -> Void)
    {
        self.url = url
        self.title = title
        self.selectedTags = selectedTags
        self.onEditTitle = onEditTitle
        self.onTapSaveButton = onTapSaveButton
        self.onSelectTags = onSelectTags
    }

    // MARK: - View

    public var body: some View {
        VStack {
            TsundocMetaContainer(url: url, title: title) {
                isTitleEditAlertPresenting = true
            }

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
            let viewStore = tagMultiAdditionViewStoreBuilder.buildTagMultiAdditionViewStore(selectedIds: selectedTags)
            TagMultiAdditionView(store: viewStore) {
                isTagEditSheetPresenting = false
                onSelectTags($0)
            }
        }
        .alert(isPresenting: $isTitleEditAlertPresenting,
               text: title,
               config: .init(title: L10n.tsundocEditViewTitleEditTitle,
                             message: L10n.tsundocEditViewTitleEditMessage,
                             placeholder: L10n.tsundocEditViewTitleEditPlaceholder,
                             validator: { title != $0 && $0?.count ?? 0 > 0 },
                             saveAction: { onEditTitle($0) },
                             cancelAction: nil))
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
