//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
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
                    SafariView(url: tsundoc.url)

                default:
                    EmptyView()
                }
            }
        }
    }
}

struct TsundocList_Previews: PreviewProvider {
    static func makeTsundoc(title: String,
                            description: String? = nil,
                            imageUrl: URL? = nil,
                            emojiAlias: String? = nil) -> Tsundoc
    {
        return .init(id: UUID(),
                     title: title,
                     description: description,
                     // swiftlint:disable:next force_unwrapping
                     url: URL(string: "https://www.apple.com")!,
                     imageUrl: imageUrl,
                     emojiAlias: emojiAlias,
                     updatedDate: Date(),
                     createdDate: Date())
    }

    static var previews: some View {
        let tsundocs: [Tsundoc] = [
            makeTsundoc(title: "hoge", emojiAlias: "+1"),
            makeTsundoc(title: "fuga", emojiAlias: "smile"),
            makeTsundoc(title: "piyo", emojiAlias: "ghost")
        ]
        let store = Store(initialState: TsundocListState(tsundocs: tsundocs),
                          dependency: (),
                          reducer: TsundocListReducer())
        let viewStore = ViewStore(store: store)
        TsundocList(store: viewStore)
    }
}
