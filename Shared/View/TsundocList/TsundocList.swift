//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

struct TsundocList: View {
    // MARK: - Properties

    let title: String
    @StateObject var store: ViewStore<TsundocListState, TsundocListAction, TsundocListDependency>

    // MARK: - View

    var body: some View {
        NavigationView {
            List {
                ForEach(store.state.tsundocs) { tsundoc in
                    TsundocCell(tsundoc: tsundoc)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            store.execute(.select(tsundoc))
                        }
                }
                .onDelete { offsets in
                    withAnimation {
                        store.execute(.delete(offsets))
                    }
                }
            }
            .navigationTitle(title)
            .sheet(isPresented: store.bind(\.isModalPresenting, action: { _ in .dismissModal })) {
                switch store.state.modal {
                case let .safariView(tsundoc):
                    #if os(iOS)
                    NavigationView {
                        BrowseView(baseUrl: tsundoc.url,
                                   isPresenting: store.bind(\.isModalPresenting,
                                                            action: { _ in .dismissModal }))
                    }
                    .ignoresSafeArea()
                    #elseif os(macOS)
                    EmptyView()
                    #endif

                default:
                    EmptyView()
                }
            }
            .alert(isPresented: store.bind(\.isAlertPresenting, action: { _ in .dismissAlert })) {
                switch store.state.alert {
                case .failedToDelete:
                    return Alert(title: Text("tsundoc_list_error_title_delete"))

                default:
                    fatalError("Invalid Alert")
                }
            }
        }
        .onAppear {
            store.execute(.onAppear)
        }
    }
}

struct TsundocList_Previews: PreviewProvider {
    class DummyDependency: TsundocListDependency {
        var tsundocCommandService: TsundocCommandService {
            let service = TsundocCommandServiceMock()
            service.beginHandler = {}
            service.commitHandler = {}
            service.deleteTsundocHandler = { _ in .success(()) }
            return service
        }

        var tsundocQueryService: TsundocQueryService {
            let tsundocs: [Tsundoc] = [
                // swiftlint:disable:next force_unwrapping
                .makeDefault(title: "hoge", url: URL(string: "https://www.apple.com")!, emojiAlias: "+1"),
                // swiftlint:disable:next force_unwrapping
                .makeDefault(title: "fuga", url: URL(string: "https://www.apple.com")!, emojiAlias: "smile"),
                // swiftlint:disable:next force_unwrapping
                .makeDefault(title: "piyo", url: URL(string: "https://www.apple.com")!, emojiAlias: "ghost")
            ]
            let entities = ObservedTsundocArrayMock(values: .init(tsundocs))
                .eraseToAnyObservedEntityArray()
            let service = TsundocQueryServiceMock()
            service.queryAllTsundocsHandler = {
                return .success(entities)
            }
            return service
        }
    }

    static var previews: some View {
        let store = Store(initialState: TsundocListState(query: .all),
                          dependency: DummyDependency(),
                          reducer: TsundocListReducer())
        let viewStore = ViewStore(store: store)
        TsundocList(title: L10n.tsundocListTitle, store: viewStore)
    }
}
