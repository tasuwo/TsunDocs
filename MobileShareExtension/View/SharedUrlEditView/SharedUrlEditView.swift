//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

struct SharedUrlEditView: View {
    // MARK: - Properties

    @StateObject var store: ViewStore<SharedUrlEditViewState, SharedUrlEditViewAction, SharedUrlEditViewDependency>

    // MARK: - View

    var body: some View {
        VStack {
            if let url = store.state.sharedUrl {
                VStack {
                    Text(url.absoluteString)
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
