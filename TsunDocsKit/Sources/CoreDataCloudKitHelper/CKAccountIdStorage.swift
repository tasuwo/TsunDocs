//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Combine

public protocol CKAccountIdStorage {
    var lastLoggedInCKAccountId: String? { get }
    func set(lastLoggedInCKAccountId: String?)
}
