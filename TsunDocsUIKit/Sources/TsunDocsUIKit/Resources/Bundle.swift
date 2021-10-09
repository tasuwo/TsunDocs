//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

extension Bundle {
    class Class {}
    static var this: Bundle { Bundle(for: Class.self) }
    public static var tsunDocsUiKit: Bundle { Bundle(for: Class.self) }
}
