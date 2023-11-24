//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

public enum SettingViewAction: Action {
    // MARK: View Life-Cycle

    case onAppear

    // MARK: State Observation

    case iCloudSyncSettingUpdated(isEnabled: Bool)
    case cloudKitAvailabilityUpdated(isAvailable: Bool?)
    case markAsReadAutomatically(isEnabled: Bool)

    // MARK: Control

    case iCloudSyncAvailabilityChanged(isEnabled: Bool)
    case markAsReadAutomaticallyChanged(isEnabled: Bool)

    // MARK: Alert Completion

    case iCloudForceTurnOffConfirmed
    case iCloudForceTurnOnConfirmed
    case iCloudTurnOffConfirmed
    case alertDismissed
}
