//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

public struct TagSelectionView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var engine: TextEngine = .init(debounceFor: 0.3)
    @StateObject var store: ViewStore<TagSelectionViewState, TagSelectionViewAction, TagSelectionViewDependency>

    // MARK: - View

    public var body: some View {
        TagGrid(tags: store.state.tags.orderedFilteredEntities())
            .searchable(text: $engine.input, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle(Text("tag_selection_view_title", bundle: Bundle.this))
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: engine.output) { query in
                store.execute(.queryUpdated(query), animation: .default)
            }
    }
}

struct TagSelectionView_Previews: PreviewProvider {
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

        @State var selectedTag: Tag?
        @State var isPresenting: Bool = false

        var selectedTagName: String {
            guard let tag = selectedTag else {
                return "No tags selected."
            }
            return tag.name
        }

        var body: some View {
            let store = Store(initialState: TagSelectionViewState(tags: tags),
                              dependency: (),
                              reducer: TagSelectionViewReducer())
            let viewStore = ViewStore(store: store)

            VStack {
                Text(selectedTagName)
                    .sheet(isPresented: $isPresenting) {
                        NavigationView {
                            TagSelectionView(store: viewStore)
                        }
                    }
                    .padding()

                Button {
                    isPresenting = true
                } label: {
                    Text("Select tag")
                }
            }
        }
    }

    static var previews: some View {
        Container()
    }
}
