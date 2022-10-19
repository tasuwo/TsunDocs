//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import Environment
import Foundation
import SwiftUI

public struct SettingView: View {
    public typealias Store = ViewStore<SettingViewState, SettingViewAction, SettingViewDependency>

    @StateObject var store: Store

    @AppStorage(StorageKey.userInterfaceStyle.rawValue) var userInterfaceStyle = UserInterfaceStyle.unspecified

    // MARK: - Initializers

    public init(store: Store) {
        self._store = .init(wrappedValue: store)
    }

    // MARK: - View

    public var body: some View {
        List {
            Section(header: Text("setting_view.section.appearance.title", bundle: Bundle.module)) {
                NavigationLink(value: AppRoute.UserInterfaceStyleSetting()) {
                    HStack(spacing: 12) {
                        Image(systemName: "square.lefthalf.filled")
                            .foregroundColor(.gray)
                        Text("setting_view.row.user_interface_style.title", bundle: Bundle.module)
                        Spacer()
                        userInterfaceStyle.text
                            .foregroundColor(.secondary)
                    }
                }
            }

            Section(header: Text("setting_view.section.sync.title", bundle: Bundle.module),
                    footer: Text("setting_view.section.sync.footer.title", bundle: Bundle.module)) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.clockwise.icloud.fill")
                        .foregroundColor(Color.cyan)
                    Toggle(isOn: store.bind(\.iCloudSyncToggleState.isOn, action: { .iCloudSyncAvailabilityChanged(isEnabled: $0) })) {
                        Text("setting_view.row.icloud_sync.title", bundle: Bundle.module)
                    }
                    .disabled(store.state.iCloudSyncToggleState.isLoading)
                }
            }

            Section(header: Text("setting_view.section.this_app.title", bundle: Bundle.module)) {
                HStack(spacing: 12) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.orange)
                    Text("setting_view.row.app_version.title", bundle: Bundle.module)
                    Spacer()
                    Text(store.state.appVersion)
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
        .navigationDestination(for: AppRoute.UserInterfaceStyleSetting.self) { _ in
            UserInterfaceStyleSettingView()
        }
    }
}

#if DEBUG
import Combine
import CoreDataCloudKitHelper
import PreviewContent

struct SettingView_Previews: PreviewProvider {
    class Dependency: SettingViewDependency {
        private var availability: CurrentValueSubject<CloudKitAvailability?, Never>
        private var isiCloudSyncEnabled: CurrentValueSubject<Bool, Never> = .init(false)

        private var cancellables: Set<AnyCancellable> = .init()

        var cloudKitAvailabilityObserver: CloudKitAvailabilityObservable
        var userSettingStorage: UserSettingStorage

        init(cloudKitAvailability: CloudKitAvailability?) {
            let storage = UserSettingStorageMock()
            storage.isiCloudSyncEnabled = isiCloudSyncEnabled.eraseToAnyPublisher()
            storage.isiCloudSyncEnabledValue = false
            userSettingStorage = storage

            availability = .init(cloudKitAvailability)
            let observer = CloudKitAvailabilityObservableMock()
            observer.availability = availability.mapError({ _ in NSError() }).eraseToAnyPublisher()
            observer.fetchAvailabilityHandler = { .unavailable }
            cloudKitAvailabilityObserver = observer

            isiCloudSyncEnabled
                .assign(to: \.isiCloudSyncEnabledValue, on: storage)
                .store(in: &cancellables)
        }
    }

    struct ContentView: View {
        @StateObject var store: ViewStore<SettingViewState, SettingViewAction, SettingViewDependency>
        @StateObject var router: StackRouter = .init()

        public init(cloudKitAvailability: CloudKitAvailability?) {
            let store = Store(initialState: SettingViewState(appVersion: "1.0"),
                              dependency: Dependency(cloudKitAvailability: cloudKitAvailability),
                              reducer: SettingViewReducer())
            let viewStore = ViewStore(store: store)
            self._store = .init(wrappedValue: viewStore)
        }

        var body: some View {
            NavigationStack(path: $router.stack) {
                SettingView(store: store)
            }
        }
    }

    static var previews: some View {
        Group {
            ContentView(cloudKitAvailability: nil)
            ContentView(cloudKitAvailability: .unavailable)
            ContentView(cloudKitAvailability: .available(accountId: "id"))
        }
    }
}

#endif
