//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI
import TsunDocsUIKit

public struct SharedUrlEditView: View {
    public typealias RootStore = ViewStore<
        SharedUrlEditViewRootState,
        SharedUrlEditViewRootAction,
        SharedUrlEditViewRootDependency
    >

    // MARK: - Properties

    @ObservedObject var store: RootStore
    // TODO: DI方法を検討する
    private let tagSelectionViewDependency: TagSelectionViewDependency

    // MARK: - Initializers

    public init(_ store: RootStore,
                tagSelectionViewDependency: TagSelectionViewDependency)
    {
        self._store = ObservedObject(wrappedValue: store)
        self.tagSelectionViewDependency = tagSelectionViewDependency
    }

    // MARK: - Methods

    private func metaDataContainer(_ url: URL) -> some View {
        HStack(alignment: .top) {
            VStack {
                SharedUrlImage(store: store
                    .proxy(SharedUrlEditViewRootState.mappingToImage,
                           SharedUrlEditViewRootAction.mappingToImage)
                    .viewStore())
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if let title = store.state.sharedUrlTitle, !title.isEmpty {
                        Text(title)
                            .lineLimit(3)
                            .font(.body)
                    } else {
                        Text("shared_url_edit_view_no_title", bundle: Bundle.this)
                            .foregroundColor(.gray)
                            .font(.title3)
                    }

                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.cyan)
                        .font(.system(size: 24))
                }
                .onTapGesture {
                    store.execute(.edit(.onTapEditTitleButton))
                }

                Text(url.absoluteString)
                    .lineLimit(2)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding([.top, .bottom], SharedUrlImage.padding)

            Spacer()
        }
    }

    private func tagContainer() -> some View {
        VStack {
            HStack {
                Text("Tags")

                Spacer()

                Image(systemName: "plus")
                    .foregroundColor(.cyan)
                    .font(.system(size: 24))
                    .onTapGesture {
                        store.execute(.edit(.onTapEditTagButton))
                    }
            }

            Group {
                if !store.state.selectedTags.isEmpty {
                    TagGrid(
                        store: store
                            .proxy(SharedUrlEditViewRootState.mappingToTagGrid,
                                   SharedUrlEditViewRootAction.mappingToTagGrid)
                            .viewStore(),
                        inset: 0
                    )
                } else {
                    Text("No Tags")
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 100)
        }
        .padding([.leading, .trailing], SharedUrlImage.padding)
    }

    // MARK: - View

    public var body: some View {
        VStack {
            if let url = store.state.sharedUrl {
                VStack {
                    metaDataContainer(url)

                    Divider()

                    tagContainer()

                    Divider()

                    Button {
                        store.execute(.edit(.onTapSaveButton))
                    } label: {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("shared_url_edit_view_save_button", bundle: Bundle.this)
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding()
                }
                .padding(8)
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

                default:
                    fatalError("Invalid Alert")
                }
            })
        .sheet(isPresented: store.bind(\.isTagEditSheetPresenting,
                                       action: { _ in .edit(.alertDismissed) })) {
            let selectedIds = Set(store.state.selectedTags.map(\.id))
            let _store = Store(initialState: TagSelectionViewState(selectedIds: selectedIds),
                               dependency: tagSelectionViewDependency,
                               reducer: tagSelectionViewReducer)
            let viewStore = ViewStore(store: _store)
            TagSelectionView(store: viewStore,
                             onDone: { store.execute(.edit(.onSelectedTags($0))) })
        }
        .alert(isPresenting: store.bind(\.isTitleEditAlertPresenting,
                                        action: { _ in .edit(.alertDismissed) }),
               text: store.state.sharedUrlTitle ?? "",
               config: .init(title: "shared_url_edit_view_title_edit_title".localized,
                             message: "shared_url_edit_view_title_edit_message".localized,
                             placeholder: "shared_url_edit_view_title_edit_placeholder".localized,
                             validator: { text in
                                 store.state.sharedUrlTitle != text && text?.count ?? 0 > 0
                             },
                             saveAction: { store.execute(.edit(.onSaveTitle($0))) },
                             cancelAction: nil))
    }
}

struct SharedUrlEditView_Previews: PreviewProvider {
    class Dependency: SharedUrlEditViewRootDependency & TagSelectionViewDependency {
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

        // MARK: TagSelectionViewDependency

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
            SharedUrlEditView(makeStore(dependency: dependency01),
                              tagSelectionViewDependency: dependency01)
                .environment(\.imageLoaderFactory, imageLoaderFactory)

            let dependency02 = makeDependency(sharedUrl: URL(string: "https://apple.com/"),
                                              title: nil,
                                              description: nil,
                                              imageUrl: nil)
            SharedUrlEditView(makeStore(dependency: dependency02),
                              tagSelectionViewDependency: dependency02)
                .environment(\.imageLoaderFactory, imageLoaderFactory)

            let dependency03 = makeDependency(sharedUrl: URL(string: "https://apple.com/\(String(repeating: "long/", count: 100))"),
                                              title: String(repeating: "Title ", count: 100),
                                              description: String(repeating: "Description ", count: 100),
                                              imageUrl: URL(string: "https://localhost/\(String(repeating: "long/", count: 100))"))
            SharedUrlEditView(makeStore(dependency: dependency03),
                              tagSelectionViewDependency: dependency03)
                .environment(\.imageLoaderFactory, imageLoaderFactory)
        }
    }

    static func makeStore(dependency: Dependency) -> SharedUrlEditView.RootStore {
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
