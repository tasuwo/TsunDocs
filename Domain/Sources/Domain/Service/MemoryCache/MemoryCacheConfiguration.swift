//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

public struct MemoryCacheConfiguration {
    public static let `default` = MemoryCacheConfiguration(
        costLimit: Int(Self.defaultCostLimit()),
        countLimit: Int.max
    )

    public let costLimit: Int
    public let countLimit: Int

    public init(costLimit: Int, countLimit: Int) {
        self.costLimit = costLimit
        self.countLimit = countLimit
    }

    public static func defaultCostLimit() -> UInt64 {
        let totalMemory = ProcessInfo.processInfo.physicalMemory
        return totalMemory / 4
    }
}
