//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import SwiftUI

struct ContentView: View {
    @StateObject var container: SceneDependencyContainer

    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    var body: some View {
        let viewStore = container.buildTsundocListStore()

        if idiom == .pad {
            NavigationView {
                List {
                    NavigationLink(destination: TsundocList(store: viewStore)) {
                        TabItem.tsundocList.label
                    }
                    NavigationLink(destination: Text("TODO")) {
                        TabItem.tags.label
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

                Text("TODO")
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
