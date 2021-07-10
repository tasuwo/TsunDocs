//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

extension String {
    var localized: String {
        NSLocalizedString(self, tableName: nil, bundle: Bundle.this, value: "", comment: self)
    }
}
