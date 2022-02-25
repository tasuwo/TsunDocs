//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

public enum CloudKitAvailability: Equatable {
    public enum Context: Equatable {
        case none
        case accountChanged
    }

    case available(Context)
    case unavailable
}
