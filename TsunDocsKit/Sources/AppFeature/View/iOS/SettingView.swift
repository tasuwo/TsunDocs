//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation
import SwiftUI

struct SettingView: View {
    // swiftlint:disable:next force_cast force_unwrapping
    let appVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("setting_view_section_title_this_app", bundle: Bundle.module)) {
                    HStack {
                        Text("setting_view_row_app_version", bundle: Bundle.module)
                        Spacer()
                        Text(appVersion)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(Text("setting_view_title", bundle: Bundle.module))
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
