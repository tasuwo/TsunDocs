//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Foundation

public struct ViewNotification {
    public struct Name: Equatable {
        let rawValue: String
    }

    public struct UserInfoKey: Equatable, Hashable {
        let rawValue: String
    }

    public let id: UUID
    public let name: Name
    public let userInfo: [AnyHashable: Any]?
}

extension ViewNotification {
    var notification: Notification {
        Notification(name: name.notificationName, object: nil, userInfo: userInfo)
    }
}

public extension ViewNotification.Name {
    internal var notificationName: Notification.Name { .init(rawValue) }

    init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    init(_ name: Notification.Name) {
        rawValue = name.rawValue
    }
}

public extension ViewNotification.UserInfoKey {
    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}
