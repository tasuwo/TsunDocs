//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import Environment
import SwiftUI
import UIComponent

public struct TsundocCreateView: View {
    public typealias Store = ViewStore<
        TsundocCreateViewState,
        TsundocCreateViewAction,
        TsundocCreateViewDependency
    >

    // MARK: - Properties

    @StateObject var store: Store
    private let onDone: (Bool) -> Void

    @Environment(\.tagMultiSelectionSheetBuilder) private var sheetBuilder

    // MARK: - Initializers

    public init(_ store: Store, onDone: @escaping (Bool) -> Void) {
        self._store = StateObject(wrappedValue: store)
        self.onDone = onDone
    }

    // MARK: - View

    public var body: some View {
        VStack {
            TsundocEditView(url: store.state.url,
                            imageUrl: store.state.sharedUrlImageUrl,
                            isPreparing: store.state.isPreparing,
                            title: store.bind(\.title,
                                              action: { .onSaveTitle($0) }),
                            selectedEmojiInfo: store.bind(\.selectedEmojiInfo,
                                                          action: { .onSelectedEmojiInfo($0) }),
                            selectedTags: store.bind(\.selectedTags,
                                                     action: { .onSelectedTags($0) }),
                            isUnread: store.bind(\.isUnread,
                                                 action: { .onToggleUnread($0) })) {
                store.execute(.onTapSaveButton)
            } tagMultiSelectionSheetBuilder: {
                AnyView(sheetBuilder.buildTagMultiSelectionSheet(selectedIds: $0, onDone: $1))
            }
        }
        .onAppear {
            store.execute(.onAppear)
        }
        .onChange(of: store.state.isSucceeded) { isSucceeded in
            guard let result = isSucceeded else { return }
            onDone(result)
        }
        .alert(isPresented: store.bind(\.isAlertPresenting,
                                       action: { _ in .alertDismissed }), content: {
                switch store.state.alert {
                case .failedToSaveSharedUrl:
                    return Alert(title: Text(""),
                                 message: Text("shared_url_edit_view_error_title_save_url", bundle: Bundle.this),
                                 dismissButton: .default(Text("alert_close", bundle: Bundle.this), action: { store.execute(.errorConfirmed) }))

                case .none:
                    fatalError("Invalid Alert")
                }
            })
    }
}

// MARK: - Preview

#if DEBUG
import PreviewContent

struct TsundocCreateView_Previews: PreviewProvider {
    class Dependency: TsundocCreateViewDependency {
        var urlLoader: URLLoadable { _sharedUrlLoader }
        var webPageMetaResolver: WebPageMetaResolvable { _webPageMetaResolver }
        var tsundocCommandService: TsundocCommandService { _tsundocCommandService }
        var sharedUserSettingStorage: SharedUserSettingStorage { _sharedUserSettingStorage }

        var _sharedUrlLoader = URLLoadableMock()
        var _webPageMetaResolver = WebPageMetaResolvableMock()
        var _tsundocCommandService = TsundocCommandServiceMock()
        var _sharedUserSettingStorage = SharedUserSettingStorageMock()
    }

    static var previews: some View {
        Group {
            let dependency01 = makeDependency(sharedUrl: URL(string: "https://apple.com"),
                                              title: "My Title",
                                              description: "Web Page Description",
                                              imageUrl: URL(string: "https://localhost"))
            TsundocCreateView(makeStore(dependency: dependency01), onDone: { _ in })

            let dependency02 = makeDependency(sharedUrl: URL(string: "https://apple.com/"),
                                              title: nil,
                                              description: nil,
                                              imageUrl: nil)
            TsundocCreateView(makeStore(dependency: dependency02), onDone: { _ in })

            let dependency03 = makeDependency(sharedUrl: URL(string: "https://apple.com/\(String(repeating: "long/", count: 100))"),
                                              title: String(repeating: "Title ", count: 100),
                                              description: String(repeating: "Description ", count: 100),
                                              imageUrl: URL(string: "https://localhost/\(String(repeating: "long/", count: 100))"))
            TsundocCreateView(makeStore(dependency: dependency03), onDone: { _ in })
        }
    }

    static func makeStore(dependency: Dependency) -> TsundocCreateView.Store {
        let store = Store(initialState: .init(url: URL(string: "https://localhost")!),
                          dependency: dependency,
                          reducer: TsundocCreateViewReducer())
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

#endif
