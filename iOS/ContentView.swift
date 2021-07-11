//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import SwiftUI

struct ContentView: View {
    @StateObject var container: SceneDependencyContainer

    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    var body: some View {
        let tsundocListStore = container.buildTsundocListStore()
        let tagListStore = container.buildTagListStore()

        if idiom == .pad {
            NavigationView {
                List {
                    NavigationLink(destination: TsundocList(store: tsundocListStore)) {
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

                TsundocList(store: tsundocListStore)
            }
        } else {
            TabView {
                TsundocList(store: tsundocListStore)
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
            ContentView(container: SceneDependencyContainer(AppDependencyContainer()))
                .previewDevice("iPhone 12")

            ContentView(container: SceneDependencyContainer(AppDependencyContainer()))
                .previewDevice("iPad Pro (12.9-inch) (3rd generation)")
        }
    }
}
