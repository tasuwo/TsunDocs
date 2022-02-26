//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import Foundation
import SwiftUI

struct SettingView: View {
    typealias Store = ViewStore<SettingViewState, SettingViewAction, SettingViewDependency>

    @StateObject var store: Store

    @AppStorage(StorageKey.userInterfaceStyle.rawValue) var userInterfaceStyle = UserInterfaceStyle.unspecified

    // MARK: - View

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

            Section(header: Text("setting_view.section.sync.title", bundle: Bundle.module),
                    footer: Text("setting_view.section.sync.footer.title", bundle: Bundle.module)) {
                HStack {
                    Toggle(isOn: store.bind(\.iCloudSyncToggleState.isOn, action: { .iCloudSyncAvailabilityChanged(isEnabled: $0) })) {
                        Text("setting_view.row.icloud_sync.title", bundle: Bundle.module)
                    }
                    .disabled(store.state.iCloudSyncToggleState.isLoading)
                }
            }

            Section(header: Text("setting_view.section.this_app.title", bundle: Bundle.module)) {
                HStack {
                    Text("setting_view.row.app_version.title", bundle: Bundle.module)
                    Spacer()
                    Text(store.state.appVersion ?? "")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(Text("setting_view.title", bundle: Bundle.module))
        .listStyle(InsetGroupedListStyle())
        .onAppear {
            store.execute(.onAppear)
        }
        .alert(Text("setting_view.alert.turn_off_confirmation.title", bundle: Bundle.module),
               isPresented: store.bind(\.isiCloudTurnOffConfirmationPresenting, action: { _ in .alertDismissed })) {
            Button {
                store.execute(.iCloudTurnOffConfirmed, animation: .default)
            } label: {
                Text("alert.action.ok", bundle: Bundle.module)
            }
            Button(role: .cancel) {
                store.execute(.alertDismissed, animation: .default)
            } label: {
                Text("alert.action.cancel", bundle: Bundle.module)
            }
        } message: {
            Text("setting_view.alert.turn_off_confirmation.message", bundle: Bundle.module)
        }
        .alert(Text("setting_view.alert.icloud_unavailable.title", bundle: Bundle.module),
               isPresented: store.bind(\.isiCloudSettingForceTurnOffConfirmationPresenting, action: { _ in .alertDismissed })) {
            Button {
                store.execute(.alertDismissed, animation: .default)
            } label: {
                Text("alert.action.ok", bundle: Bundle.module)
            }
            Button(role: .cancel) {
                store.execute(.iCloudForceTurnOffConfirmed, animation: .default)
            } label: {
                Text("setting_view.alert.icloud_unavailable.action.force_turn_off", bundle: Bundle.module)
            }
        } message: {
            Text("setting_view.alert.icloud_unavailable.message", bundle: Bundle.module)
        }
        .alert(Text("setting_view.alert.icloud_unavailable.title", bundle: Bundle.module), isPresented: store.bind(\.isiCloudSettingForceTurnOnConfirmationPresenting, action: { _ in .alertDismissed })) {
            Button {
                store.execute(.iCloudTurnOffConfirmed, animation: .default)
            } label: {
                Text("alert.action.ok", bundle: Bundle.module)
            }
            Button(role: .cancel) {
                store.execute(.iCloudForceTurnOnConfirmed, animation: .default)
            } label: {
                Text("setting_view.alert.icloud_unavailable.action.force_turn_on", bundle: Bundle.module)
            }
        } message: {
            Text("setting_view.alert.icloud_unavailable.message", bundle: Bundle.module)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // SettingView()
        }
    }
}
