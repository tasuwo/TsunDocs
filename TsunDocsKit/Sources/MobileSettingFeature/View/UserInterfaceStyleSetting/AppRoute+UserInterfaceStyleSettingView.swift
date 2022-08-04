//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Environment

enum AppRoute {
    struct UserInterfaceStyleSetting: Route {}
}

extension Route where Self == AppRoute.UserInterfaceStyleSetting {
    static func userInterfaceStyleSetting() -> Self { .init() }
}
