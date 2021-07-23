//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI
import TsunDocsUIKit

public struct SharedUrlEditView: View {
    public typealias Store = ViewStore<
        SharedUrlEditViewRootState,
        SharedUrlEditViewRootAction,
        SharedUrlEditViewRootDependency
    >

    struct StoreBuilder: TsundocEditThumbnailStoreBuildable, TagGridStoreBuildable {
        let store: Store

        func buildTsundocEditThumbnailStore() -> ViewStore<TsundocEditThumbnailState, TsundocEditThumbnailAction, TsundocEditThumbnailDependency> {
            return store.tsundocEditThumbnailStore
        }

        func buildTagGridStore() -> ViewStore<TagGridState, TagGridAction, TagGridDependency> {
            return store.tagGridStore
        }
    }

    // MARK: - Properties

    @StateObject var store: Store

    // MARK: - Initializers

    public init(_ store: Store) {
        self._store = StateObject(wrappedValue: store)
    }

    // MARK: - View

    public var body: some View {
        VStack {
            if let url = store.state.sharedUrl {
                TsundocEditView(url: url,
                                title: store.state.sharedUrlTitle ?? "",
                                selectedTags: Set(store.state.selectedTags.map(\.id))) {
                    store.execute(.edit(.onSaveTitle($0)))
                } onTapSaveButton: {
                    store.execute(.edit(.onTapSaveButton))
                } onSelectTags: {
                    store.execute(.edit(.onSelectedTags($0)))
                }
                .environment(\.tagGridStoreBuilder, StoreBuilder(store: store))
                .environment(\.tsundocEditThumbnailStoreBuilder, StoreBuilder(store: store))
            } else {
                ProgressView()
                    .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
            }
        }
        .onAppear {
            store.execute(.edit(.onAppear))
        }
        .alert(isPresented: store.bind(\.isAlertPresenting,
                                       action: { _ in .edit(.alertDismissed) }), content: {
                switch store.state.alert {
                case .failedToLoadUrl:
                    return Alert(title: Text(""),
                                 message: Text("shared_url_edit_view_error_title_load_url", bundle: Bundle.this),
                                 dismissButton: .default(Text("alert_close", bundle: Bundle.this), action: { store.execute(.edit(.errorConfirmed)) }))

                case .failedToSaveSharedUrl:
                    return Alert(title: Text(""),
                                 message: Text("shared_url_edit_view_error_title_save_url", bundle: Bundle.this),
                                 dismissButton: .default(Text("alert_close", bundle: Bundle.this), action: { store.execute(.edit(.errorConfirmed)) }))

                case .none:
                    fatalError("Invalid Alert")
                }
            })
    }
}

// MARK: - Preview

@MainActor
struct SharedUrlEditView_Previews: PreviewProvider {
    class Dependency: SharedUrlEditViewRootDependency & TagMultiAdditionViewDependency {
        // MARK: SharedUrlEditViewRootDependency

        class Complete: Completable {
            func complete() {}
            func cancel(with: Error) {}
        }

        var sharedUrlLoader: SharedUrlLoadable { _sharedUrlLoader }
        var webPageMetaResolver: WebPageMetaResolvable { _webPageMetaResolver }
        var tsundocCommandService: TsundocCommandService { _tsundocCommandService }
        var completable: Completable { _completable }

        var _sharedUrlLoader = SharedUrlLoadableMock()
        var _webPageMetaResolver = WebPageMetaResolvableMock()
        var _tsundocCommandService = TsundocCommandServiceMock()
        var _completable = Complete()

        // MARK: TagMultiAdditionViewDependency

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

    class StoreBuilder: TagMultiAdditionViewStoreBuildable {
        private let dependency: TagMultiAdditionViewDependency

        init(dependency: TagMultiAdditionViewDependency) {
            self.dependency = dependency
        }

        func buildTagMultiAdditionViewStore(selectedIds: Set<Tag.ID>) -> ViewStore<TagMultiAdditionViewState, TagMultiAdditionViewAction, TagMultiAdditionViewDependency> {
            let store = Store(initialState: TagMultiAdditionViewState(selectedIds: selectedIds),
                              dependency: dependency,
                              reducer: tagMultiAdditionViewReducer)
            return ViewStore(store: store)
        }
    }

    class SuccessMock: URLProtocolMockBase {
        override class var mock_delay: TimeInterval? { 3 }
        override class var mock_handler: ((URLRequest) throws -> (HTTPURLResponse, Data?))? {
            // swiftlint:disable:next force_unwrapping
            return { _ in (.mock_success, UIImage(named: "320x320", in: Bundle.this, with: nil)!.pngData()) }
        }
    }

    static var previews: some View {
        let imageLoaderFactory = Factory<ImageLoader> {
            .init(urlSession: .makeMock(SuccessMock.self))
        }

        Group {
            let dependency01 = makeDependency(sharedUrl: URL(string: "https://apple.com"),
                                              title: "My Title",
                                              description: "Web Page Description",
                                              imageUrl: URL(string: "https://localhost"))
            SharedUrlEditView(makeStore(dependency: dependency01))
                .environment(\.imageLoaderFactory, imageLoaderFactory)
                .environment(\.tagMultiAdditionViewStoreBuilder, StoreBuilder(dependency: dependency01))

            let dependency02 = makeDependency(sharedUrl: URL(string: "https://apple.com/"),
                                              title: nil,
                                              description: nil,
                                              imageUrl: nil)
            SharedUrlEditView(makeStore(dependency: dependency02))
                .environment(\.imageLoaderFactory, imageLoaderFactory)
                .environment(\.tagMultiAdditionViewStoreBuilder, StoreBuilder(dependency: dependency02))

            let dependency03 = makeDependency(sharedUrl: URL(string: "https://apple.com/\(String(repeating: "long/", count: 100))"),
                                              title: String(repeating: "Title ", count: 100),
                                              description: String(repeating: "Description ", count: 100),
                                              imageUrl: URL(string: "https://localhost/\(String(repeating: "long/", count: 100))"))
            SharedUrlEditView(makeStore(dependency: dependency03))
                .environment(\.imageLoaderFactory, imageLoaderFactory)
                .environment(\.tagMultiAdditionViewStoreBuilder, StoreBuilder(dependency: dependency03))
        }
    }

    static func makeStore(dependency: Dependency) -> SharedUrlEditView.Store {
        let store = Store(initialState: SharedUrlEditViewRootState(),
                          dependency: dependency,
                          reducer: sharedUrlEditViewRootReducer)
        let viewStore = ViewStore(store: store)
        return viewStore
    }

    static func makeDependency(sharedUrl: URL?,
                               title: String?,
                               description: String?,
                               imageUrl: URL?) -> Dependency
    {
        let dependency = Dependency()

        dependency._sharedUrlLoader.loadHandler = { completion in
            completion(sharedUrl)
        }

        dependency._webPageMetaResolver.resolveHandler = { _ in
            return WebPageMeta(title: title, description: description, imageUrl: imageUrl)
        }

        return dependency
    }
}
