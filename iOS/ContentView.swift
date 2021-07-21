//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import SwiftUI

struct ContentView: View {
    @Environment(\.sceneDependencyContainer) var container

    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    var body: some View {
        let tsundocListStore = container.buildTsundocListStore(query: .all)
        let tagListStore = container.buildTagListStore()
        let tsundocList = TsundocList(title: L10n.tsundocListTitle, store: tsundocListStore)

        if idiom == .pad {
            NavigationView {
                List {
                    NavigationLink(destination: tsundocList) {
                        TabItem.tsundocList.label
                    }
                    NavigationLink(destination: TagList(store: tagListStore)) {
                        TabItem.tags.label
                    }
                    NavigationLink(destination: SettingView()) {
                        TabItem.settings.label
                    }
                }
                .navigationTitle(LocalizedStringKey("app_name"))
                .listStyle(SidebarListStyle())

                tsundocList
            }
        } else {
            TabView {
                tsundocList
                    .tabItem { TabItem.tsundocList.view }

                TagList(store: tagListStore)
                    .tabItem { TabItem.tags.view }

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
