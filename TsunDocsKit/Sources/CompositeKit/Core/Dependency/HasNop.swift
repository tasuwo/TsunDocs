//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

public protocol HasNop {}

public struct Nop: HasNop {
    public init() {}
}
