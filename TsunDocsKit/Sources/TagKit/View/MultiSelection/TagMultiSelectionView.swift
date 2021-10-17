//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import SearchKit
import SwiftUI

public struct TagMultiSelectionView: View {
    public typealias FilterStore = ViewStore<
        SearchableFilterState<Tag>,
        SearchableFilterAction<Tag>,
        SearchableFilterDepenency
    >

    // MARK: - Properties

    @State private var selectedIds: Set<Tag.ID> = .init()

    @StateObject var filterStore: FilterStore
    @StateObject var engine: TextEngine = .init(debounceFor: 0.3)

    // MARK: - Initializers

    public init(tags: [Tag]) {
        let store = Store(initialState: .init(items: tags),
                          dependency: Nop(),
                          reducer: SearchableFilterReducer<Tag>())
        _filterStore = StateObject(wrappedValue: ViewStore(store: store))
    }

    // MARK: - View

    public var body: some View {
        TagGrid(tags: filterStore.state.filteredItems,
                selectedIds: selectedIds,
                configuration: .init(.selectable(.multiple),
                                     size: .normal,
                                     isEnabledMenu: false)) { action in
            switch action {
            case let .select(tagId):
                if selectedIds.contains(tagId) {
                    selectedIds.subtract([tagId])
                } else {
                    selectedIds = selectedIds.union([tagId])
                }

            default:
                // NOP
                break
            }
        }
        .searchable(text: $engine.input, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle(Text("tag_multi_selection_view_title", bundle: Bundle.module))
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: engine.output) { query in
            filterStore.execute(.updateQuery(query), animation: .default)
        }
    }
}

// MARK: - Preview

@MainActor
struct TagMultiSelectionView_Previews: PreviewProvider {
    struct ContentView: View {
        // MARK: - Properties

        @State private var tags: [Tag]
        @State private var isPresenting = false

        // MARK: - Initializers

        init(tags: [Tag]) {
            self.tags = tags
        }

        // MARK: - View

        var body: some View {
            VStack {
                Button {
                    isPresenting = true
                } label: {
                    Text("Select tag")
                }
                .sheet(isPresented: $isPresenting) {
                    NavigationView {
                        TagMultiSelectionView(tags: tags)
                    }
                }
            }
        }
    }

    static let tags: [Tag] = [
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

    static var previews: some View {
        ContentView(tags: tags)
    }
}
