//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

struct SharedUrlEditView: View {
    typealias RootStore = ViewStore<SharedUrlEditViewRootState,
        SharedUrlEditViewRootAction,
        SharedUrlEditViewRootDependency>
    typealias Store = ViewStore<SharedUrlEditViewState,
        SharedUrlEditViewAction,
        SharedUrlEditViewDependency>

    // MARK: - Properties

    @StateObject var rootStore: RootStore
    @StateObject var store: Store

    // MARK: - Initializers

    init(_ rootStore: RootStore) {
        self._rootStore = StateObject(wrappedValue: rootStore)

        let store: Store = rootStore
            .proxy(SharedUrlEditViewRootState.mappingToEdit,
                   SharedUrlEditViewRootAction.mappingToEdit)
            .viewStore()
        self._store = StateObject(wrappedValue: store)
    }

    // MARK: - View

    var body: some View {
        VStack {
            if let url = store.state.sharedUrl {
                VStack {
                    SharedUrlImage(store: rootStore
                        .proxy(SharedUrlEditViewRootState.mappingToImage,
                               SharedUrlEditViewRootAction.mappingToImage)
                        .viewStore())

                    Text(store.state.sharedUrlTitle ?? "no title")
                    Text(store.state.sharedUrlDescription ?? "no description")
                    Text(store.state.sharedUrlImageUrl?.absoluteString ?? "no image url")
                    Button("保存") {
                        store.execute(.onTapButton)
                    }
                }
            } else {
                ProgressView()
                    .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
            }
        }
        .onAppear {
            store.execute(.onAppear)
        }
        .alert(isPresented: store.bind(\.isAlertPresenting, action: { _ in .alertDismissed }), content: {
            switch store.state.alert {
            case .failedToLoadUrl:
                return Alert(title: Text(""),
                             message: Text("shared_url_edit_view_error_title_load_url"),
                             dismissButton: .default(Text("alert_close"), action: { store.execute(.errorConfirmed) }))

            case .failedToSaveSharedUrl:
                return Alert(title: Text(""),
                             message: Text("shared_url_edit_view_error_title_save_url"),
                             dismissButton: .default(Text("alert_close"), action: { store.execute(.errorConfirmed) }))

            default:
                fatalError("Invalid Alert")
            }
        })
    }
}

struct SharedUrlEditView_Previews: PreviewProvider {
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

    static let dependency: Dependency = {
        let dependency = Dependency()

        dependency._sharedUrlLoader.loadHandler = { completion in
            completion(URL(string: "https://apple.com"))
        }

        dependency._webPageMetaResolver.resolveHandler = { _ in
            return WebPageMeta(title: "My Title", description: "Web Page Description", imageUrl: nil)
        }

        return dependency
    }()

    static var previews: some View {
        let store = Store(initialState: SharedUrlEditViewRootState(),
                          dependency: dependency,
                          reducer: sharedUrlEditViewRootReducer)
        let viewStore = ViewStore(store: store)

        SharedUrlEditView(viewStore)
    }
}
