//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import SwiftUI

struct ContentView: View {
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    var body: some View {
        let store = Store(initialState: TsundocListState(tsundocs: []),
                          dependency: (),
                          reducer: TsundocListReducer())
        let viewStore = ViewStore(store: store)

        if idiom == .pad {
            NavigationView {
                List {
                    NavigationLink(destination: TsundocList(store: viewStore)) {
                        TabItem.tsundocList.label
                    }
                    NavigationLink(destination: SettingView()) {
                        TabItem.settings.label
                    }
                }
                .navigationTitle(LocalizedStringKey("app_name"))
                .listStyle(SidebarListStyle())

                TsundocList(store: viewStore)
            }
        } else {
            TabView {
                TsundocList(store: viewStore)
                    .tabItem { TabItem.tsundocList.view }

                SettingView()
                    .tabItem { TabItem.settings.view }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 12")

            ContentView()
                .previewDevice("iPad Pro (12.9-inch) (3rd generation)")
        }
    }
}
