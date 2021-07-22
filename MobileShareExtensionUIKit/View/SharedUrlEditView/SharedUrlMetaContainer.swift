//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI
import TsunDocsUIKit

struct SharedUrlMetaContainer: View {
    typealias Store = ViewStore<
        SharedUrlEditViewRootState,
        SharedUrlEditViewRootAction,
        SharedUrlEditViewRootDependency
    >

    // MARK: - Properties

    @ObservedObject var store: Store

    // MARK: - Initializers

    init(store: Store) {
        self._store = ObservedObject(wrappedValue: store)
    }

    // MARK: - View

    var body: some View {
        if let url = store.state.sharedUrl {
            HStack(alignment: .top) {
                VStack {
                    TsundocEditThumbnail(store: store
                        .proxy(SharedUrlEditViewRootState.mappingToImage,
                               SharedUrlEditViewRootAction.mappingToImage)
                        .viewStore())
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        if let title = store.state.sharedUrlTitle, !title.isEmpty {
                            Text(title)
                                .lineLimit(4)
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
                .padding([.top, .bottom], TsundocEditThumbnail.padding)

                Spacer()
            }
        } else {
            EmptyView()
        }
    }
}

// MARK: - Preview

struct SharedUrlMetaContainer_Previews: PreviewProvider {
    class Dependency: SharedUrlEditViewRootDependency {
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

        VStack {
            Divider()

            let meta01 = WebPageMeta(title: "My Title",
                                     description: "Web Page Description",
                                     imageUrl: URL(string: "https://localhost"))
            SharedUrlMetaContainer(store: makeStore(url: URL(string: "https://apple.com"), meta: meta01))
                .environment(\.imageLoaderFactory, imageLoaderFactory)

            Divider()

            let meta02 = WebPageMeta(title: nil,
                                     description: nil,
                                     imageUrl: nil)
            SharedUrlMetaContainer(store: makeStore(url: URL(string: "https://apple.com"), meta: meta02))
                .environment(\.imageLoaderFactory, imageLoaderFactory)

            Divider()

            let meta03 = WebPageMeta(title: String(repeating: "Title ", count: 100),
                                     description: String(repeating: "Description ", count: 100),
                                     imageUrl: URL(string: "https://localhost/\(String(repeating: "long/", count: 100))"))
            SharedUrlMetaContainer(store: makeStore(url: URL(string: "https://apple.com/\(String(repeating: "long/", count: 100))"),
                                                    meta: meta03))
                .environment(\.imageLoaderFactory, imageLoaderFactory)

            Divider()
        }
    }

    static func makeStore(url: URL?, meta: WebPageMeta) -> SharedUrlEditView.RootStore {
        let store = Store(initialState: SharedUrlEditViewRootState(sharedUrlImageUrl: meta.imageUrl,
                                                                   selectedEmoji: nil,
                                                                   sharedUrl: url,
                                                                   sharedUrlTitle: meta.title,
                                                                   sharedUrlDescription: meta.description,
                                                                   selectedTags: [],
                                                                   alert: nil,
                                                                   isTitleEditAlertPresenting: false,
                                                                   isTagEditSheetPresenting: false,
                                                                   thumbnailLoadingStatus: nil,
                                                                   isSelectingEmoji: false),
                          dependency: Dependency(),
                          reducer: sharedUrlEditViewRootReducer)
        let viewStore = ViewStore(store: store)
        return viewStore
    }
}
