//
//  Copyright ©︎ 2023 Tasuku Tozawa. All rights reserved.
//

import Foundation

public extension URL {
    static var managedObjectModelUrl: URL {
        return Bundle.module.url(forResource: "Model", withExtension: "momd")!
    }
}
