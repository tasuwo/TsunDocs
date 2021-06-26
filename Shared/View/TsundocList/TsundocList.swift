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
            }
            .navigationTitle("tsundoc_list_title")
            .sheet(isPresented: store.bind(\.isModalPresenting, action: { _ in .modalDismissed })) {
                switch store.state.modal {
                case let .safariView(tsundoc):
                    #if os(iOS)
                        SafariView(url: tsundoc.url)
                    #elseif os(macOS)
                        WebView(url: tsundoc.url)
                    #endif

                default:
                    EmptyView()
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
        var tsundocQueryService: TsundocQueryService {
            let tsundocs: [Tsundoc] = [
                makeTsundoc(title: "hoge", emojiAlias: "+1"),
                makeTsundoc(title: "fuga", emojiAlias: "smile"),
                makeTsundoc(title: "piyo", emojiAlias: "ghost")
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

    static func makeTsundoc(title: String, emojiAlias: String?) -> Tsundoc {
        return .init(id: UUID(),
                     title: title,
                     description: nil,
                     // swiftlint:disable:next force_unwrapping
                     url: URL(string: "https://www.apple.com")!,
                     imageUrl: nil,
                     emojiAlias: emojiAlias,
                     updatedDate: Date(),
                     createdDate: Date())
    }

    static var previews: some View {
        let store = Store(initialState: TsundocListState(),
                          dependency: DummyDependency(),
                          reducer: TsundocListReducer())
        let viewStore = ViewStore(store: store)
        TsundocList(store: viewStore)
    }
}
