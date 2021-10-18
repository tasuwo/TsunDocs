//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

public struct TagMultiSelectionSheet: View {
    public typealias ControlStore = ViewStore<
        TagControlState,
        TagControlAction,
        TagControlDependency
    >

    // MARK: - Properties

    private let selectedIds: Set<Tag.ID>

    @StateObject private var store: ControlStore

    private let onDone: ([Tag]) -> Void

    // MARK: - Initializers

    public init(selectedIds: Set<Tag.ID>,
                viewStore: ControlStore,
                onDone: @escaping ([Tag]) -> Void)
    {
        self.selectedIds = selectedIds
        _store = StateObject(wrappedValue: viewStore)
        self.onDone = onDone
    }

    // MARK: - View

    public var body: some View {
        NavigationView {
            TagMultiSelectionView(selectedIds: selectedIds,
                                  connection: store.connection(at: \.tags, { .updateItems($0) })) { action in
                switch action {
                case let .addNewTag(name: name):
                    store.execute(.createNewTag(name), animation: .default)

                case let .done(selected: ids):
                    onDone(store.state.tags.filter { ids.contains($0.id) })
                }
            }
        }
        .onAppear {
            store.execute(.onAppear)
        }
        .alert(isPresented: store.bind(\.isFailedToCreateTagAlertPresenting,
                                       action: { _ in .alertDismissed })) {
            Alert(title: Text("tag_multi_selection_sheet_alert_failed_to_create_tag_title", bundle: Bundle.module))
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
                    let store = Store(initialState: TagControlState(),
                                      dependency: TagControlDependencyMock(),
                                      reducer: TagControlReducer())
                    let viewStore = ViewStore(store: store)
                    TagMultiSelectionSheet(selectedIds: .init(),
                                           viewStore: viewStore,
                                           onDone: { _ in isPresenting = false })
                }
            }
        }
    }

    static var previews: some View {
        Container()
    }
}
