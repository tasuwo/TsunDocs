//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

enum TabItem: CaseIterable {
    case tsundocList
    case settings

    var label: some View {
        switch self {
        case .tsundocList:
            return Label("tab_item_title_tsundoc_list", systemImage: "list.bullet")

        case .settings:
            return Label("tab_item_title_settings", systemImage: "gear")
        }
    }

    var view: some View {
        switch self {
        case .tsundocList:
            return VStack {
                Image(systemName: "list.bullet")
                Text("tab_item_title_tsundoc_list")
            }

        case .settings:
            return VStack {
                Image(systemName: "gear")
                Text("tab_item_title_settings")
            }
        }
    }
}
