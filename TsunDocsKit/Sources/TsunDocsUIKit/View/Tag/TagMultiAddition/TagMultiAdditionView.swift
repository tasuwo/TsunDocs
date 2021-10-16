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

#if DEBUG
import PreviewContent
#endif

@MainActor
struct TagSelectionView_Previews: PreviewProvider {
    class Dependency: TagMultiAdditionViewDependency {
        var tags: AnyObservedEntityArray<Tag> = {
            let tags: [Tag] = [
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
                let newTag = Tag(id: id,
                                 name: String(UUID().uuidString.prefix(5)),
                                 tsundocsCount: 5)

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
