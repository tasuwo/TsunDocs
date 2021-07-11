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
            store.execute(.filter(.queryUpdated(query)), animation: .default)
        }
    }
}

struct TagMultiSelectionView_Previews: PreviewProvider {
    class Dependency: HasNop {}

    struct Container: View {
        private let tags: [Tag] = [
            .init(id: UUID(), name: "This"),
            .init(id: UUID(), name: "is"),
            .init(id: UUID(), name: "Flexible"),
            .init(id: UUID(), name: "Gird"),
            .init(id: UUID(), name: "Layout"),
            .init(id: UUID(), name: "for"),
            .init(id: UUID(), name: "Tags."),
            .init(id: UUID(), name: "This"),
            .init(id: UUID(), name: "Layout"),
            .init(id: UUID(), name: "allows"),
            .init(id: UUID(), name: "displaying"),
            .init(id: UUID(), name: "very"),
            .init(id: UUID(), name: "long"),
            .init(id: UUID(), name: "tag"),
            .init(id: UUID(), name: "names"),
            .init(id: UUID(), name: "like"),
            .init(id: UUID(), name: "Too Too Too Too Long Tag"),
            .init(id: UUID(), name: "or"),
            .init(id: UUID(), name: "Toooooooooooooo Loooooooooooooooooooooooong Tag."),
            .init(id: UUID(), name: "All"),
            .init(id: UUID(), name: "cell"),
            .init(id: UUID(), name: "sizes"),
            .init(id: UUID(), name: "are"),
            .init(id: UUID(), name: "flexible")
        ]

        @State var isPresenting: Bool = false

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
