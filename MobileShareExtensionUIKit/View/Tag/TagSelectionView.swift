//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI
import TsunDocsUIKit

struct TagSelectionView: View {
    typealias Store = ViewStore<
        TagSelectionViewState,
        TagSelectionViewAction,
        TagSelectionViewDependency
    >
    typealias ControlStore = ViewStore<
        TagControlState,
        TagControlAction,
        TagControlDependency
    >
    typealias SelectionStore = ViewStore<
        TagMultiSelectionViewState,
        TagMultiSelectionViewAction,
        TagMultiSelectionViewDependency
    >

    @ObservedObject var store: Store
    @ObservedObject var controlStore: ControlStore

    // MARK: - Initializers

    init(store: Store) {
        _store = ObservedObject(wrappedValue: store)
        _controlStore = ObservedObject(wrappedValue:
            store
                .proxy(TagSelectionViewState.mappingToControl,
                       TagSelectionViewAction.mappingToControl)
                .viewStore()
        )
    }

    // MARK: - View

    var body: some View {
        NavigationView {
            TagMultiSelectionView(store:
                store
                    .proxy(TagSelectionViewState.mappingToMultiSelection,
                           TagSelectionViewAction.mappingToMultiSelection)
                    .viewStore()
            )
            .onAppear {
                controlStore.execute(.onAppear)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        controlStore.execute(.didTapAddButton)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        controlStore.execute(.didTapDoneButton)
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
        .alert(isPresenting: controlStore.bind(\.isTagAdditionAlertPresenting,
                                               action: { _ in .alertDismissed }),
               text: "",
               config: .init(title: "Add New Tag",
                             message: "Enter",
                             placeholder: "Tag Name",
                             validator: { $0?.count ?? 0 > 0 },
                             saveAction: { controlStore.execute(.didSaveTag($0)) },
                             cancelAction: nil))
    }
}

// MARK: - Preview

struct TagSelectionView_Previews: PreviewProvider {
    class Dependency: TagSelectionViewDependency {
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
        @State var isPresenting: Bool = false

        var body: some View {
            let store = Store(initialState: TagSelectionViewState(),
                              dependency: Dependency(),
                              reducer: tagSelectionViewReducer)
            let viewStore = ViewStore(store: store)

            VStack {
                Button {
                    isPresenting = true
                } label: {
                    Text("Select tag")
                }
                .sheet(isPresented: $isPresenting) {
                    TagSelectionView(store: viewStore)
                }
            }
        }
    }

    static var previews: some View {
        Container()
    }
}
