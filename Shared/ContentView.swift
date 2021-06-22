//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    var body: some View {
        if idiom == .pad {
            NavigationView {
                List {
                    NavigationLink(destination: Text("TODO: TsundocList")) {
                        TabItem.tsundocList.label
                    }
                    NavigationLink(destination: Text("TODO: SettingView")) {
                        TabItem.settings.label
                    }
                }
                .navigationTitle(LocalizedStringKey("app_name"))
                .listStyle(SidebarListStyle())

                Text("TODO: TsundocList")
            }
        } else {
            TabView {
                Text("TODO: TsundocList")
                    .tabItem { TabItem.tsundocList.view }

                Text("TODO: SettingView")
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
