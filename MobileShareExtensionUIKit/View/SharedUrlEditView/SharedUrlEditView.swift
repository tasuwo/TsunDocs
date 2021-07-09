//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI
import TsunDocsUIKit

public struct SharedUrlEditView: View {
    public typealias RootStore = ViewStore<SharedUrlEditViewRootState,
        SharedUrlEditViewRootAction,
        SharedUrlEditViewRootDependency>
    typealias Store = ViewStore<SharedUrlEditViewState,
        SharedUrlEditViewAction,
        SharedUrlEditViewDependency>

    // MARK: - Properties

    @StateObject var rootStore: RootStore
    @StateObject var store: Store

    // MARK: - Initializers

    public init(_ rootStore: RootStore) {
        self._rootStore = StateObject(wrappedValue: rootStore)

        let store: Store = rootStore
            .proxy(SharedUrlEditViewRootState.mappingToEdit,
                   SharedUrlEditViewRootAction.mappingToEdit)
            .viewStore()
        self._store = StateObject(wrappedValue: store)
    }

    // MARK: - View

    public var body: some View {
        VStack {
            if let url = store.state.sharedUrl {
                VStack {
                    SharedUrlImage(store: rootStore
                        .proxy(SharedUrlEditViewRootState.mappingToImage,
                               SharedUrlEditViewRootAction.mappingToImage)
                        .viewStore())

                    Spacer()
                        .frame(height: 16)
                        .fixedSize()

                    Text(url.absoluteString)
                        .foregroundColor(.gray)
                        .font(.caption)
                        .padding(.bottom)

                    HStack {
                        if let title = store.state.sharedUrlTitle, !title.isEmpty {
                            Text(title)
                                .font(.title2)
                        } else {
                            Text("shared_url_edit_view_no_title", bundle: Bundle.this)
                                .foregroundColor(.gray)
                                .font(.title2)
                        }

                        Spacer()
                            .frame(width: 16)
                            .fixedSize()

                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.cyan)
                            .font(.title2)
                            .onTapGesture {
                                store.execute(.onTapEditTitleButton)
                            }
                    }
                    .padding()

                    Button {
                        store.execute(.onTapSaveButton)
                    } label: {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("shared_url_edit_view_save_button", bundle: Bundle.this)
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding()
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
                             message: Text("shared_url_edit_view_error_title_load_url", bundle: Bundle.this),
                             dismissButton: .default(Text("alert_close", bundle: Bundle.this), action: { store.execute(.errorConfirmed) }))

            case .failedToSaveSharedUrl:
                return Alert(title: Text(""),
                             message: Text("shared_url_edit_view_error_title_save_url", bundle: Bundle.this),
                             dismissButton: .default(Text("alert_close", bundle: Bundle.this), action: { store.execute(.errorConfirmed) }))

            default:
                fatalError("Invalid Alert")
            }
        })
        .alert(isPresenting: store.bind(\.isTitleEditAlertPresenting,
                                        action: { _ in .alertDismissed }),
               text: store.state.sharedUrlTitle ?? "",
               config: .init(title: "shared_url_edit_view_title_edit_title".localized,
                             message: "shared_url_edit_view_title_edit_message".localized,
                             placeholder: "shared_url_edit_view_title_edit_placeholder".localized,
                             validator: { text in
                                 store.state.sharedUrlTitle != text && text?.count ?? 0 > 0
                             },
                             saveAction: { store.execute(.onSaveTitle($0)) },
                             cancelAction: nil))
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
            return WebPageMeta(title: "My Title",
                               description: "Web Page Description",
                               imageUrl: URL(string: "https://localhost"))
        }

        return dependency
    }()

    class SuccessMock: URLProtocolMockBase {
        override class var mock_delay: TimeInterval? { 3 }
        override class var mock_handler: ((URLRequest) throws -> (HTTPURLResponse, Data?))? {
            // swiftlint:disable:next force_unwrapping
            return { _ in (.mock_success, UIImage(named: "320x320", in: Bundle.this, with: nil)!.pngData()) }
        }
    }

    static var previews: some View {
        let store = Store(initialState: SharedUrlEditViewRootState(),
                          dependency: dependency,
                          reducer: sharedUrlEditViewRootReducer)
        let viewStore = ViewStore(store: store)
        let imageLoaderFactory = Factory<ImageLoader> {
            .init(urlSession: .makeMock(SuccessMock.self))
        }

        SharedUrlEditView(viewStore)
            .environment(\.imageLoaderFactory, imageLoaderFactory)
    }
}
