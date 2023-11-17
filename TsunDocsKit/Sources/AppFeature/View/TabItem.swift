//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SplitView
import SwiftUI

enum TabItem: String, CaseIterable {
    case tsundocList
    case tags
    case settings

    var name: String {
        switch self {
        case .tsundocList:
            String(localized: "tab_item_title_tsundoc_list", bundle: .module)

        case .tags:
            String(localized: "tab_item_title_tags", bundle: .module)

        case .settings:
            String(localized: "tab_item_title_settings", bundle: .module)
        }
    }

    var iconName: String {
        switch self {
        case .tsundocList:
            "list.bullet"

        case .tags:
            "tag"

        case .settings:
            "gear"
        }
    }

    var label: some View {
        Label {
            Text(name)
        } icon: {
            Image(systemName: iconName)
        }
    }

    var tabIcon: some View {
        VStack {
            Image(systemName: iconName)
            Text(name)
        }
    }
}

extension TabItem: SidebarItem {
    static var order: [TabItem] = allCases

    var text: String { name }
    var image: UIImage { return UIImage(systemName: iconName)! }
}
