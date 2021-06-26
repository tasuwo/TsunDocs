//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

struct TsundocList: View {
    // MARK: - Properties

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
                        store.execute(.onDelete(offsets))
                    }
                }
            }
            .navigationTitle("tsundoc_list_title")
            .sheet(isPresented: store.bind(\.isModalPresenting, action: { _ in .modalDismissed })) {
                switch store.state.modal {
                case let .safariView(tsundoc):
                    #if os(iOS)
                        SafariView(url: tsundoc.url)
                            .ignoresSafeArea()
                    #elseif os(macOS)
                        WebView(url: tsundoc.url)
                    #endif

                default:
                    EmptyView()
                }
            }
            .alert(isPresented: store.bind(\.isAlertPresenting, action: { _ in .alertDismissed })) {
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
                .makeDefault(title: "hoge", emojiAlias: "+1"),
                .makeDefault(title: "fuga", emojiAlias: "smile"),
                .makeDefault(title: "piyo", emojiAlias: "ghost")
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
        let store = Store(initialState: TsundocListState(),
                          dependency: DummyDependency(),
                          reducer: TsundocListReducer())
        let viewStore = ViewStore(store: store)
        TsundocList(store: viewStore)
    }
}
