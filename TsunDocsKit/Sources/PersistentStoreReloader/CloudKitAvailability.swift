//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

public enum CloudKitAvailability: Equatable {
    case available(accountId: String)
    case unavailable
}
