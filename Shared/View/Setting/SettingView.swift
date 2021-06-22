//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    // swiftlint:disable:next force_cast force_unwrapping
    let appVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("setting_view_section_title_this_app")) {
                    HStack {
                        Text("setting_view_row_app_version")
                        Spacer()
                        Text(appVersion)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("setting_view_title")
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
