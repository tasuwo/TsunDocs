//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation
import MobileShareExtensionUIKit

extension NSExtensionContext: Completable {
    public func complete() {
        completeRequest(returningItems: nil, completionHandler: nil)
    }

    public func cancel(with error: Error) {
        cancelRequest(withError: error)
    }
}
