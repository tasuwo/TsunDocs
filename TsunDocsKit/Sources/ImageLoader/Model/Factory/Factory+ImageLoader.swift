//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

public extension Factory where T == ImageLoader {
    static var `default`: Self { .init { ImageLoader() } }
}
