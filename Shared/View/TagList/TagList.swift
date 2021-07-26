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

    @Environment(\.tsundocListStoreBuilder) var tsundocListSotreBuilder

    // MARK: - View

    var body: some View {
        NavigationView {
            TagGrid(
                store: store
                    .proxy(TagListState.mappingToGird,
                           TagListAction.mappingToGird)
                    .viewStore()
            )
            .searchable(text: $engine.input)
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
            .background(
                NavigationLink(destination: tsundocList(),
                               isActive: store.bind(\.controlState.isTsundocListNavigationActive,
                                                    action: { _ in .control(.navigation(.deactivated)) })) {
                    EmptyView()
                }
            )
        }
        // HACK: https://forums.swift.org/t/14-5-beta3-navigationlink-unexpected-pop/45279/35
        .navigationViewStyle(StackNavigationViewStyle())
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
        .background(
            // HACK: View表示が崩れるため、背景に配置する
            Color.clear
                .frame(width: 0, height: 0)
                .fixedSize()
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
        )
    }

    @ViewBuilder
    private func tsundocList() -> some View {
        if case let .tsundocList(tagId) = store.state.controlState.navigation,
           let tag = store.state.gridState.tags.first(where: { $0.id == tagId })
        {
            let store = tsundocListSotreBuilder.buildTsundocListStore(query: .tagged(tagId))
            TsundocList(title: tag.name,
                        emptyTitle: L10n.tsundocListEmptyMessageTagMessage(tag.name),
                        emptyMessage: nil,
                        store: store)
        } else {
            EmptyView()
        }
    }
}

// MARK: - Preview

@MainActor
struct TagList_Previews: PreviewProvider {
    class Dependency: TagListDependency {
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
