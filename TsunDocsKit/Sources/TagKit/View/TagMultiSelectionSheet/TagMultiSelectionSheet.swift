//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

public struct TagMultiSelectionSheet: View {
    public typealias Store = ViewStore<
        TagMultiSelectionState,
        TagMultiSelectionAction,
        TagMultiSelectionDependency
    >

    // MARK: - Properties

    @StateObject private var store: Store

    private let onDone: ([Tag]) -> Void

    // MARK: - Initializers

    public init(store: Store,
                onDone: @escaping ([Tag]) -> Void)
    {
        _store = StateObject(wrappedValue: store)
        self.onDone = onDone
    }

    // MARK: - View

    public var body: some View {
        NavigationView {
            TagMultiSelectionView(selectedIds: store.bind(\.selectedIds, action: { .updatedSelectedTags($0) }),
                                  connection: store.connection(at: \.tags, { .updateItems($0) })) { action in
                switch action {
                case let .addNewTag(name: name):
                    store.execute(.createNewTag(name), animation: .default)

                case .done:
                    onDone(store.state.selectedTags)
                }
            }
        }
        .onAppear {
            store.execute(.onAppear)
        }
        .alert(isPresented: store.bind(\.isFailedToCreateTagAlertPresenting,
                                       action: { _ in .alertDismissed })) {
            Alert(title: Text("tag_multi_selection_sheet_alert_failed_to_create_tag_title", bundle: Bundle.this))
        }
    }
}

// MARK: - Preview

@MainActor
struct TagSelectionView_Previews: PreviewProvider {
    struct Container: View {
        @State var isPresenting = false

        var body: some View {
            VStack {
                Button {
                    isPresenting = true
                } label: {
                    Text("Select tag")
                }
                .sheet(isPresented: $isPresenting) {
                    let store = Store(initialState: TagMultiSelectionState(),
                                      dependency: TagMultiSelectionDependencyMock(),
                                      reducer: TagMultiSelectionReducer())
                    let viewStore = ViewStore(store: store)
                    TagMultiSelectionSheet(store: viewStore,
                                           onDone: { _ in isPresenting = false })
                }
            }
        }
    }

    static var previews: some View {
        Container()
    }
}
