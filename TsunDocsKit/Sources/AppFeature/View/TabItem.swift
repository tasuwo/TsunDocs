//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case tsundocList
    case tags
    case settings

    var label: some View {
        switch self {
        case .tsundocList:
            return Label {
                Text("tab_item_title_tsundoc_list", bundle: .module)
            } icon: {
                Image(systemName: "list.bullet")
            }

        case .tags:
            return Label {
                Text("tab_item_title_tags", bundle: .module)
            } icon: {
                Image(systemName: "tag")
            }

        case .settings:
            return Label {
                Text("tab_item_title_settings", bundle: .module)
            } icon: {
                Image(systemName: "gear")
            }
        }
    }

    var view: some View {
        switch self {
        case .tsundocList:
            return VStack {
                Image(systemName: "list.bullet")
                Text("tab_item_title_tsundoc_list", bundle: .module)
            }

        case .tags:
            return VStack {
                Image(systemName: "tag")
                Text("tab_item_title_tags", bundle: .module)
            }

        case .settings:
            return VStack {
                Image(systemName: "gear")
                Text("tab_item_title_settings", bundle: .module)
            }
        }
    }
}
