//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import struct Domain.Tag
import SearchKit
import SwiftUI
import TextEditAlert

public struct TagMultiSelectionView: View {
    public typealias Store = ViewStore<
        SearchableFilterState<Tag>,
        SearchableFilterAction<Tag>,
        SearchableFilterDepenency
    >

    // MARK: - Properties

    @State private var selectedIds: Set<Tag.ID> = .init()
    @State private var isAdditionDialogPresenting = false

    @StateObject private var store: Store
    @StateObject private var engine: TextEngine = .init(debounceFor: 0.3)

    private let onPerform: (Action) -> Void

    // MARK: - Initializers

    public init(selectedIds: Set<Tag.ID>,
                connection: Connection<SearchableFilterAction<Tag>>,
                onPerform: @escaping (Action) -> Void)
    {
        _selectedIds = State(initialValue: selectedIds)
        let store = CompositeKit.Store(initialState: .init(items: []),
                                       dependency: Nop(),
                                       reducer: SearchableFilterReducer<Tag>())
            .connect(connection)
            .eraseToAnyStoring()
        _store = StateObject(wrappedValue: ViewStore(store: store))
        self.onPerform = onPerform
    }

    // MARK: - View

    public var body: some View {
        TagGrid(tags: store.state.filteredItems,
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
            store.execute(.updateQuery(query), animation: .default)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isAdditionDialogPresenting = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    onPerform(.done(selected: selectedIds))
                } label: {
                    Text("tag_multi_selection_view_done_button", bundle: Bundle.module)
                }
            }
        }
        .alert(
            isPresenting: $isAdditionDialogPresenting,
            text: "",
            config: .init(title: NSLocalizedString("tag_multi_selection_view_alert_new_tag_title", bundle: Bundle.module, comment: ""),
                          message: NSLocalizedString("tag_multi_selection_view_alert_new_tag_message", bundle: Bundle.module, comment: ""),
                          placeholder: NSLocalizedString("tag_multi_selection_view_alert_new_tag_placeholder", bundle: Bundle.module, comment: ""),
                          validator: { $0?.isEmpty == false },
                          saveAction: { onPerform(.addNewTag(name: $0)) },
                          cancelAction: nil)
        )
    }
}

// MARK: - Preview

#if DEBUG
import Combine
#endif

@MainActor
struct TagMultiSelectionView_Previews: PreviewProvider {
    struct ContentView: View {
        // MARK: - Properties

        private var tags: CurrentValueSubject<[Tag], Never>

        @State private var selectedIds: Set<Tag.ID> = .init()
        @State private var isPresenting = false

        var selectedTags: [Tag] {
            tags.value.filter { selectedIds.contains($0.id) }
        }

        var connection: Connection<SearchableFilterAction<Tag>> {
            tags
                .map { SearchableFilterAction<Tag>.updateItems($0) }
                .eraseToAnyPublisher()
        }

        // MARK: - Initializers

        init(tags: [Tag]) {
            self.tags = .init(tags)
        }

        // MARK: - View

        var body: some View {
            VStack(spacing: 12) {
                Button {
                    isPresenting = true
                } label: {
                    Text("Select tag")
                }
                Text("Selected: \(Array(selectedTags.map(\.name)).joined(separator: ", "))")
            }
            .sheet(isPresented: $isPresenting) {
                NavigationView {
                    TagMultiSelectionView(selectedIds: selectedIds, connection: connection) { action in
                        switch action {
                        case let .addNewTag(name: name):
                            withAnimation {
                                self.tags.send(self.tags.value + [.init(id: UUID(), name: name)])
                            }

                        case let .done(selected: ids):
                            selectedIds = ids
                            isPresenting = false
                        }
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
