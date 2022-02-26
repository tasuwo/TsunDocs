//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import Foundation
import SwiftUI

struct SettingView: View {
    // swiftlint:disable:next force_cast force_unwrapping
    let appVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    @AppStorage(StorageKey.userInterfaceStyle.rawValue) var userInterfaceStyle = UserInterfaceStyle.unspecified

    var body: some View {
        List {
            Section(header: Text("setting_view.section.appearance.title", bundle: Bundle.module)) {
                NavigationLink(destination: UserInterfaceStyleSettingView()) {
                    HStack {
                        Text("setting_view.row.user_interface_style.title", bundle: Bundle.module)
                        Spacer()
                        userInterfaceStyle.text
                            .foregroundColor(.secondary)
                    }
                }
            }

            Section(header: Text("setting_view.section.this_app.title", bundle: Bundle.module)) {
                HStack {
                    Text("setting_view.row.app_version.title", bundle: Bundle.module)
                    Spacer()
                    Text(appVersion)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(Text("setting_view.title", bundle: Bundle.module))
        .listStyle(InsetGroupedListStyle())
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingView()
        }
    }
}
