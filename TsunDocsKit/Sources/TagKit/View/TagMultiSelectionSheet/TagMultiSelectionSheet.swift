//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

public struct TagMultiSelectionSheet: View {
    public typealias ControlStore = ViewStore<
        TagControlState,
        TagControlAction,
        TagControlDependency
    >

    // MARK: - Properties

    @StateObject private var store: ControlStore

    private let onDone: ([Tag]) -> Void

    // MARK: - Initializers

    public init(viewStore: ControlStore,
                onDone: @escaping ([Tag]) -> Void)
    {
        _store = StateObject(wrappedValue: viewStore)
        self.onDone = onDone
    }

    // MARK: - View

    public var body: some View {
        NavigationView {
            TagMultiSelectionView(connection: store.connection(at: \.tags, { .updateItems($0) })) { action in
                switch action {
                case let .addNewTag(name: name):
                    store.execute(.createNewTag(name), animation: .default)

                case let .done(selected: ids):
                    onDone(store.state.tags.filter { ids.contains($0.id) })
                }
            }
        }
        .onAppear {
            store.execute(.onAppear)
        }
        .alert(isPresented: store.bind(\.isFailedToCreateTagAlertPresenting,
                                       action: { _ in .alertDismissed })) {
            Alert(title: Text("tag_multi_selection_sheet_alert_failed_to_create_tag_title", bundle: Bundle.module))
        }
    }
}

// MARK: - Preview

#if DEBUG
import PreviewContent
#endif

@MainActor
struct TagSelectionView_Previews: PreviewProvider {
    class Dependency: TagControlDependency {
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
                    let store = Store(initialState: TagControlState(),
                                      dependency: Dependency(),
                                      reducer: TagControlReducer())
                    let viewStore = ViewStore(store: store)
                    TagMultiSelectionSheet(viewStore: viewStore,
                                           onDone: { _ in isPresenting = false })
                }
            }
        }
    }

    static var previews: some View {
        Container()
    }
}
