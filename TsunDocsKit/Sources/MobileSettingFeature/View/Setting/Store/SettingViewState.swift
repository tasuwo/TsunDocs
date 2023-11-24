//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

public struct SettingViewState: Equatable {
    enum Alert: Equatable {
        case iCloudSettingForceTurnOnConfirmation
        case iCloudSettingForceTurnOffConfirmation
        case iCloudTurnOffConfirmation
    }

    enum ToggleState: Equatable {
        case on
        case off
        case loading

        var isOn: Bool {
            self == .on
        }

        var isLoading: Bool {
            self == .loading
        }
    }

    let appVersion: String
    var isiCloudSyncInternalSettingEnabled: Bool = false
    var markAsReadAutomatically: Bool = true
    var alert: Alert?
    var isCloudKitAvailable: Bool?

    // MARK: - Initializers

    public init(appVersion: String) {
        self.appVersion = appVersion
    }
}

extension SettingViewState {
    var iCloudSyncToggleState: ToggleState {
        if isSettingiCloudSync { return .loading }
        guard let isCloudKitAvailable else { return .loading }
        if isiCloudSyncInternalSettingEnabled, isCloudKitAvailable {
            return .on
        } else {
            return .off
        }
    }

    var isSettingiCloudSync: Bool {
        switch alert {
        case .iCloudTurnOffConfirmation, .iCloudSettingForceTurnOnConfirmation, .iCloudSettingForceTurnOffConfirmation:
            return true

        default:
            return false
        }
    }

    var isiCloudSettingForceTurnOnConfirmationPresenting: Bool {
        return alert == .iCloudSettingForceTurnOnConfirmation
    }

    var isiCloudSettingForceTurnOffConfirmationPresenting: Bool {
        return alert == .iCloudSettingForceTurnOffConfirmation
    }

    var isiCloudTurnOffConfirmationPresenting: Bool {
        return alert == .iCloudTurnOffConfirmation
    }
}
