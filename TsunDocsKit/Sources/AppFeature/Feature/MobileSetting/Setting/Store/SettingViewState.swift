//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CoreDataCloudKitHelper

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

    var isiCloudSyncInternalSettingEnabled: Bool = false
    var alert: Alert?
    var cloudKitAvailability: CloudKitAvailability?
    var appVersion: String?

    // MARK: - Initializers

    public init() {}
}

extension SettingViewState {
    var iCloudSyncToggleState: ToggleState {
        if isSettingiCloudSync { return .loading }
        guard let availability = cloudKitAvailability else { return .loading }
        if isiCloudSyncInternalSettingEnabled, availability.isAvailable {
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
