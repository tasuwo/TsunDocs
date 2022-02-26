//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Domain
import SwiftUI

struct UserInterfaceStyleSettingView: View {
    @AppStorage(StorageKey.userInterfaceStyle.rawValue) var userInterfaceStyle = UserInterfaceStyle.unspecified

    var body: some View {
        List(UserInterfaceStyle.allCases, id: \.self) { style in
            HStack(spacing: 0) {
                style.text

                Spacer()

                if style == userInterfaceStyle {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                userInterfaceStyle = style
            }
        }
        .navigationTitle(Text("user_interface_style_setting_view.title", bundle: Bundle.module))
        .listStyle(InsetGroupedListStyle())
    }
}

extension UserInterfaceStyle {
    var text: Text {
        switch self {
        case .dark:
            return Text("user_interface_style_setting_view.row.dark", bundle: Bundle.module)

        case .light:
            return Text("user_interface_style_setting_view.row.light", bundle: Bundle.module)

        case .unspecified:
            return Text("user_interface_style_setting_view.row.unspecified", bundle: Bundle.module)
        }
    }
}

struct UserInterfaceStyleSettingView_Previews: PreviewProvider {
    static var previews: some View {
        UserInterfaceStyleSettingView()
    }
}
