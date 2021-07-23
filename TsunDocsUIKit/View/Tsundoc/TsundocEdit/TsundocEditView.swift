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
    private let existsSelectedTags: Bool
    private let onTapEditTitleButton: () -> Void
    private let onTapSaveButton: () -> Void
    private let onTapEditTagButton: () -> Void

    private let tagGridStoreBuilder: () -> ViewStore<TagGridState, TagGridAction, TagGridDependency>

    @Environment(\.tsundocEditThumbnailStoreBuilder) var tsundocEditThumbnailStoreBuilder

    // MARK: - Initializers

    public init(url: URL,
                title: String,
                existsSelectedTags: Bool,
                tagGridStoreBuilder: @escaping () -> ViewStore<TagGridState, TagGridAction, TagGridDependency>,
                onTapEditTitleButton: @escaping () -> Void,
                onTapSaveButton: @escaping () -> Void,
                onTapEditTagButton: @escaping () -> Void)
    {
        self.url = url
        self.title = title
        self.existsSelectedTags = existsSelectedTags
        self.tagGridStoreBuilder = tagGridStoreBuilder
        self.onTapEditTitleButton = onTapEditTitleButton
        self.onTapSaveButton = onTapSaveButton
        self.onTapEditTagButton = onTapEditTagButton
    }

    // MARK: - View

    public var body: some View {
        VStack {
            TsundocMetaContainer(url: url, title: title) {
                onTapEditTitleButton()
            }
            .environment(\.tsundocEditThumbnailStoreBuilder, tsundocEditThumbnailStoreBuilder)

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
    }

    private func tagContainer() -> some View {
        VStack {
            HStack {
                Text(L10n.tsundocEditViewTagsTitle)

                Spacer()

                Image(systemName: "plus")
                    .foregroundColor(.cyan)
                    .font(.system(size: 24))
                    .onTapGesture {
                        onTapEditTagButton()
                    }
            }

            if existsSelectedTags {
                TagGrid(store: tagGridStoreBuilder(), inset: 0)
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
