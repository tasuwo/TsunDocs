//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import CoreDataCloudKitHelper

public enum SettingViewAction: Action {
    // MARK: View Life-Cycle

    case onAppear

    // MARK: State Observation

    case iCloudSyncSettingUpdated(isEnabled: Bool)
    case cloudKitAvailabilityUpdated(availability: CloudKitAvailability?)

    // MARK: Control

    case iCloudSyncAvailabilityChanged(isEnabled: Bool)

    // MARK: Alert Completion

    case iCloudForceTurnOffConfirmed
    case iCloudForceTurnOnConfirmed
    case iCloudTurnOffConfirmed
    case alertDismissed
}
