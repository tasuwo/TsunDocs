//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

public struct TagMultiSelectionView: View {
    public typealias Store = ViewStore<
        TagMultiSelectionViewState,
        TagMultiSelectionViewAction,
        TagMultiSelectionViewDependency
    >

    @StateObject var store: Store
    @StateObject var engine: TextEngine = .init(debounceFor: 0.3)

    // MARK: - Initializers

    public init(store: Store) {
        _store = StateObject(wrappedValue: store)
    }

    // MARK: - View

    public var body: some View {
        TagGrid(
            store: store
                .proxy(TagMultiSelectionViewState.mappingToGrid,
                       TagMultiSelectionViewAction.mappingToGrid)
                .viewStore()
        )
        .searchable(text: $engine.input, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle(Text("tag_selection_view_title", bundle: Bundle.this))
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: engine.output) { query in
            store.execute(.filter(.updateQuery(query)), animation: .default)
        }
    }
}

// MARK: - Preview

@MainActor
struct TagMultiSelectionView_Previews: PreviewProvider {
    class Dependency: HasNop {}

    struct Container: View {
        private let tags: [Tag] = [
            .makeDefault(id: UUID(), name: "This"),
            .makeDefault(id: UUID(), name: "is"),
            .makeDefault(id: UUID(), name: "Flexible"),
            .makeDefault(id: UUID(), name: "Gird"),
            .makeDefault(id: UUID(), name: "Layout"),
            .makeDefault(id: UUID(), name: "for"),
            .makeDefault(id: UUID(), name: "Tags."),
            .makeDefault(id: UUID(), name: "This"),
            .makeDefault(id: UUID(), name: "Layout"),
            .makeDefault(id: UUID(), name: "allows"),
            .makeDefault(id: UUID(), name: "displaying"),
            .makeDefault(id: UUID(), name: "very"),
            .makeDefault(id: UUID(), name: "long"),
            .makeDefault(id: UUID(), name: "tag"),
            .makeDefault(id: UUID(), name: "names"),
            .makeDefault(id: UUID(), name: "like"),
            .makeDefault(id: UUID(), name: "Too Too Too Too Long Tag"),
            .makeDefault(id: UUID(), name: "or"),
            .makeDefault(id: UUID(), name: "Toooooooooooooo Loooooooooooooooooooooooong Tag."),
            .makeDefault(id: UUID(), name: "All"),
            .makeDefault(id: UUID(), name: "cell"),
            .makeDefault(id: UUID(), name: "sizes"),
            .makeDefault(id: UUID(), name: "are"),
            .makeDefault(id: UUID(), name: "flexible")
        ]

        @State var isPresenting = false

        var body: some View {
            let store = Store(initialState: TagMultiSelectionViewState(tags: tags),
                              dependency: Dependency(),
                              reducer: tagMultiSelectionReducer)
            let viewStore = ViewStore(store: store)

            VStack {
                Button {
                    isPresenting = true
                } label: {
                    Text("Select tag")
                }
                .sheet(isPresented: $isPresenting) {
                    NavigationView {
                        TagMultiSelectionView(store: viewStore)
                    }
                }
            }
        }
    }

    static var previews: some View {
        Container()
    }
}
