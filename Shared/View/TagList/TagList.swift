//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI
import TsunDocsUIKit

struct TagList: View {
    typealias Store = ViewStore<
        TagListState,
        TagListAction,
        TagListDependency
    >

    @StateObject var store: Store
    @StateObject var engine: TextEngine = .init(debounceFor: 0.3)

    // MARK: - Initializers

    init(store: Store) {
        _store = StateObject(wrappedValue: store)
    }

    // MARK: - View

    var body: some View {
        NavigationView {
            TagGrid(
                store: store
                    .proxy(TagListState.mappingToGird,
                           TagListAction.mappingToGird)
                    .viewStore()
            )
            .searchable(text: $engine.input, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle(Text("tag_list_title"))
            .onChange(of: engine.output) { query in
                store.execute(.control(.updateQuery(query)), animation: .default)
            }
            .onAppear {
                store.execute(.control(.onAppear))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        store.execute(.control(.addNewTag))
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .alert(isPresented: store.bind(\.controlState.isAlertPresenting,
                                       action: { _ in .control(.alert(.dismissed)) })) {
            switch store.state.controlState.alert {
            case .plain(.failedToAddTag):
                return Alert(title: Text(L10n.errorTagAddDefault))

            case .plain(.failedToDeleteTag):
                return Alert(title: Text(L10n.errorTagDelete))

            case .plain(.failedToUpdateTag):
                return Alert(title: Text(L10n.errorTagUpdate))

            default:
                fatalError("Invalid Alert")
            }
        }
        .alert(isPresenting: store.bind(\.controlState.isTagAdditionAlertPresenting,
                                        action: { _ in .control(.alert(.dismissed)) }),
               text: "",
               config: .init(title: L10n.tagListAlertNewTagTitle,
                             message: L10n.tagListAlertNewTagMessage,
                             placeholder: L10n.tagListAlertPlaceholder,
                             validator: { $0?.count ?? 0 > 0 },
                             saveAction: { store.execute(.control(.saveNewTag($0))) },
                             cancelAction: nil))
        .alert(isPresenting: store.bind(\.controlState.isRenameAlertPresenting,
                                        action: { _ in .control(.alert(.dismissed)) }),
               text: store.state.controlState.renamingTagName ?? "",
               config: .init(title: L10n.tagListAlertUpdateTagNameTitle,
                             message: L10n.tagListAlertUpdateTagNameMessage,
                             placeholder: L10n.tagListAlertPlaceholder,
                             validator: { text in
                                 let baseTitle = store.state.controlState.renamingTagName ?? ""
                                 return text != baseTitle && text?.count ?? 0 > 0
                             },
                             saveAction: { store.execute(.control(.alert(.updatedTitle($0)))) },
                             cancelAction: nil))
    }
}

// MARK: - Preview

struct TagList_Previews: PreviewProvider {
    class Dependency: TagListDependency {
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

        var pasteboard: Pasteboard {
            return PasteboardMock()
        }
    }

    static var previews: some View {
        Group {
            let store = Store(initialState: TagListState(),
                              dependency: Dependency(),
                              reducer: tagListReducer)
            let viewStore = ViewStore(store: store)
            TagList(store: viewStore)
        }
    }
}
