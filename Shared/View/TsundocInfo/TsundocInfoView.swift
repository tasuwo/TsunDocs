//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI
import TsunDocsUIKit

struct TsundocInfoView: View {
    typealias Store = ViewStore<
        TsundocInfoViewRootState,
        TsundocInfoViewRootAction,
        TsundocInfoViewRootDependency
    >

    // MARK: - Properties

    @StateObject var store: Store

    @State private var isTagEditSheetPresenting = false

    @Environment(\.tagMultiAdditionViewStoreBuilder) var tagMultiAdditionViewStoreBuilder

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
            let viewStore = tagMultiAdditionViewStoreBuilder.buildTagMultiAdditionViewStore(selectedIds: Set(store.state.tags.map(\.id)))
            TagMultiAdditionView(store: viewStore) {
                isTagEditSheetPresenting = false
                store.execute(.info(.editTags($0)))
            }
        }
        .onAppear {
            store.execute(.info(.onAppear))
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
                TagGrid(store: store
                    .proxy(TsundocInfoViewRootState.mappingToTagGrid,
                           TsundocInfoViewRootAction.mappingToTagGrid)
                    .viewStore(),
                    inset: 0)
            } else {
                Spacer()
            }
        }
        .padding([.leading, .trailing], TsundocEditThumbnail.padding)
    }
}

// MARK: - Bind

extension ViewStore where Action == TsundocInfoViewRootAction, State == TsundocInfoViewRootState, Dependency == TsundocInfoViewRootDependency {
    func bindTitle() -> Binding<String> {
        bind { $0.tsundoc.title } action: { .info(.editTitle($0)) }
    }

    func bindEmoji() -> Binding<Emoji?> {
        bind { $0.tsundoc.emoji } action: { .info(.editEmoji($0)) }
    }

    func bindTags() -> Binding<[Tag]> {
        bind { $0.tags } action: { .info(.editTags($0)) }
    }
}

// MARK: - Previews

struct TsundocInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
