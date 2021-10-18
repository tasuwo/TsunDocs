//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI
import TagKit
import TsundocList

struct TsundocInfoView: View {
    typealias Store = ViewStore<
        TsundocInfoViewState,
        TsundocInfoViewAction,
        TsundocInfoViewDependency
    >

    // MARK: - Properties

    @StateObject var store: Store

    @State private var isTagEditSheetPresenting = false

    @Environment(\.tagControlViewStoreBuilder) var tagControlViewStoreBuilder: TagControlViewStoreBuildable

    // MARK: - View

    var body: some View {
        VStack {
            TsundocMetaContainer(url: store.state.tsundoc.url,
                                 imageUrl: store.state.tsundoc.imageUrl,
                                 title: store.bindTitle(),
                                 selectedEmoji: store.bindEmoji())

            Divider()

            tagContainer()

            Spacer()
        }
        .sheet(isPresented: $isTagEditSheetPresenting) {
            TagMultiSelectionSheet(selectedIds: Set(store.state.tags.map(\.id)),
                                   viewStore: tagControlViewStoreBuilder.buildTagControlViewStore()) {
                isTagEditSheetPresenting = false
                store.execute(.editTags($0))
            }
        }
        .onAppear {
            store.execute(.onAppear)
        }
    }

    @MainActor
    @ViewBuilder
    func tagContainer() -> some View {
        VStack {
            HStack {
                Text(L10n.tsundocInfoViewTag)

                Spacer()

                Image(systemName: "plus")
                    .foregroundColor(.cyan)
                    .font(.system(size: 24))
                    .onTapGesture {
                        isTagEditSheetPresenting = true
                    }
            }

            if !store.state.tags.isEmpty {
                TagGrid(tags: store.state.tags, selectedIds: .init(), inset: 0)
            } else {
                Spacer()
            }
        }
        .padding([.leading, .trailing], TsundocEditThumbnail.padding)
    }
}

// MARK: - Bind

extension ViewStore where Action == TsundocInfoViewAction, State == TsundocInfoViewState, Dependency == TsundocInfoViewDependency {
    func bindTitle() -> Binding<String> {
        bind { $0.tsundoc.title } action: { .editTitle($0) }
    }

    func bindEmoji() -> Binding<Emoji?> {
        bind { $0.tsundoc.emoji } action: { .editEmoji($0) }
    }

    func bindTags() -> Binding<[Tag]> {
        bind { $0.tags } action: { .editTags($0) }
    }
}

// MARK: - Previews

struct TsundocInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
