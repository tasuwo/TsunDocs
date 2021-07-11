//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: self)
    }
}
