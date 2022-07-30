//
//  Created by Tasuku Tozawa on 2021/10/11.
//

import CoreGraphics
import SwiftUI
import UIKit

extension CGFloat {
    func scaledValueWithDefaultMetrics() -> CGFloat {
        return UIFontMetrics.default.scaledValue(for: self)
    }
}
