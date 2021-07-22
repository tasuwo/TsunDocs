//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

public struct TagMultiAdditionView: View {
    public typealias Store = ViewStore<
        TagMultiAdditionViewState,
        TagMultiAdditionViewAction,
        TagMultiAdditionViewDependency
    >

    @StateObject var store: Store
    private let onDone: ([Tag]) -> Void

    // MARK: - Initializers

    public init(store: Store, onDone: @escaping ([Tag]) -> Void) {
        _store = StateObject(wrappedValue: store)
        self.onDone = onDone
    }

    // MARK: - View

    public var body: some View {
        NavigationView {
            TagMultiSelectionView(store:
                store
                    .proxy(TagMultiAdditionViewState.mappingToMultiSelection,
                           TagMultiAdditionViewAction.mappingToMultiSelection)
                    .viewStore()
            )
            .onAppear {
                store.execute(.control(.onAppear))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        store.execute(.control(.didTapAddButton))
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        onDone(store.state.selectedTags)
                    } label: {
                        Text(L10n.tagMultiAdditionViewDoneButton)
                    }
                }
            }
        }
        .alert(isPresenting: store.bind(\.controlState.isTagAdditionAlertPresenting,
                                        action: { _ in .control(.alertDismissed) }),
               text: "",
               config: .init(title: L10n.tagMultiAdditionViewAlertNewTagTitle,
                             message: L10n.tagMultiAdditionViewAlertNewTagMessage,
                             placeholder: L10n.tagMultiAdditionViewAlertNewTagPlaceholder,
                             validator: { $0?.count ?? 0 > 0 },
                             saveAction: { store.execute(.control(.didSaveTag($0))) },
                             cancelAction: nil))
    }
}

// MARK: - Preview

@MainActor
struct TagSelectionView_Previews: PreviewProvider {
    class Dependency: TagMultiAdditionViewDependency {
        var tags: AnyObservedEntityArray<Tag> = {
            let tags: [Tag] = [
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
            return ObservedTagArrayMock(values: .init(tags))
                .eraseToAnyObservedEntityArray()
        }()

        var tagCommandService: TagCommandService {
            let service = TagCommandServiceMock()
            service.performHandler = { $0() }
            service.beginHandler = {}
            service.commitHandler = {}
            service.createTagHandler = { [unowned self] _ in
                let id = UUID()
                let newTag = Tag(id: id, name: String(UUID().uuidString.prefix(5)))

                let values = self.tags.values.value
                self.tags.values.send(values + [newTag])

                return .success(id)
            }
            return service
        }

        var tagQueryService: TagQueryService {
            let service = TagQueryServiceMock()
            service.queryAllTagsHandler = { [unowned self] in
                .success(self.tags)
            }
            return service
        }
    }

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
                    let store = Store(initialState: TagMultiAdditionViewState(),
                                      dependency: Dependency(),
                                      reducer: tagMultiAdditionViewReducer)
                    let viewStore = ViewStore(store: store)
                    TagMultiAdditionView(store: viewStore,
                                         onDone: { _ in isPresenting = false })
                }
            }
        }
    }

    static var previews: some View {
        Container()
    }
}
