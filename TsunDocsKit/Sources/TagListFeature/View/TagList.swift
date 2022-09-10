//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI
import TagMultiSelectionFeature
import UIComponent

public struct TagList: View {
    public typealias Store = ViewStore<
        TagControlState,
        TagControlAction,
        TagControlDependency
    >
    public typealias FilterStore = ViewStore<
        SearchableFilterState<Tag>,
        SearchableFilterAction<Tag>,
        SearchableFilterDepenency
    >

    @StateObject var store: Store
    @StateObject var filterStore: FilterStore
    @StateObject var engine: TextEngine = .init(debounceFor: 0.3)

    @State private var isAdditionDialogPresenting = false

    // MARK: - Initializers

    public init(store: Store, filterStore: FilterStore) {
        _store = .init(wrappedValue: store)
        _filterStore = .init(wrappedValue: filterStore)
    }

    // MARK: - View

    public var body: some View {
        TagGrid(tags: filterStore.state.filteredItems,
                selectedIds: .init(),
                configuration: .init(.default, size: .normal, isEnabledMenu: true)) { action in
            switch action {
            case let .delete(tagId: tagId):
                store.execute(.deleteTag(tagId), animation: .default)

            case let .copy(tagId: tagId):
                store.execute(.copyTagName(tagId))

            case let .rename(tagId: tagId, name: name):
                store.execute(.renameTag(tagId, name: name), animation: .default)

            case let .select(tagId: tagId):
                store.execute(.selectTag(tagId))
            }
        }
        .searchable(text: $engine.input)
        .navigationTitle(Text("tag_list_title", bundle: .module))
        .onChange(of: engine.output) { query in
            filterStore.execute(.updateQuery(query), animation: .default)
        }
        .onAppear {
            store.execute(.onAppear)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isAdditionDialogPresenting = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .alert(isPresented: store.bind(\.isFailedToCreateTagAlertPresenting,
                                       action: { _ in .alertDismissed })) {
            return Alert(title: Text(L10n.errorTagAddDefault))
        }
        .alert(isPresented: store.bind(\.isFailedToDeleteTagAlertPresenting,
                                       action: { _ in .alertDismissed })) {
            return Alert(title: Text(L10n.errorTagDelete))
        }
        .alert(isPresented: store.bind(\.isFailedToRenameTagAlertPresenting,
                                       action: { _ in .alertDismissed })) {
            return Alert(title: Text(L10n.errorTagUpdate))
        }
        .alert(isPresenting: $isAdditionDialogPresenting,
               text: "",
               config: .init(title: L10n.tagListAlertNewTagTitle,
                             message: L10n.tagListAlertNewTagMessage,
                             placeholder: L10n.tagListAlertPlaceholder,
                             validator: { $0?.count ?? 0 > 0 },
                             saveAction: { store.execute(.createNewTag($0)) },
                             cancelAction: nil))
    }
}

// MARK: - Preview

struct TagList_Previews: PreviewProvider {
    static var previews: some View {
        // TODO:
        EmptyView()
    }
}
