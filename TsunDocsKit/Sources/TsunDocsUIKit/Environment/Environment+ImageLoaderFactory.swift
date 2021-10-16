//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import SwiftUI

private struct ImageLoaderFactoryKey: EnvironmentKey {
    static let defaultValue: Factory<ImageLoader> = .default
}

public extension EnvironmentValues {
    var imageLoaderFactory: Factory<ImageLoader> {
        get { self[ImageLoaderFactoryKey.self] }
        set { self[ImageLoaderFactoryKey.self] = newValue }
    }
}
