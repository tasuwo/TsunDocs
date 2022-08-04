//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Combine
import Foundation

public class ViewNotificationCenter {
    public static let `default` = ViewNotificationCenter(notificationCenter: .default)
    private static let ViewId = "net.tasuwo.tsundocs.ViewNotificationCenter.userInfoKey.id"

    private let notificationCenter: NotificationCenter

    // MARK: - Initializer

    public init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    // MARK: - Methods

    public func post(id: UUID, name: ViewNotification.Name, userInfo: [ViewNotification.UserInfoKey: Any]? = nil) {
        var info: [AnyHashable: Any] = [:]
        info[Self.ViewId] = id
        info.merge(userInfo ?? [:], uniquingKeysWith: { value, _ in value })
        notificationCenter.post(name: name.notificationName, object: nil, userInfo: info)
    }

    public func publisher(for id: UUID, name: ViewNotification.Name) -> AnyPublisher<ViewNotification, Never> {
        notificationCenter.publisher(for: name.notificationName)
            .filter { $0.userInfo?[Self.ViewId] as? UUID == id }
            .compactMap { notification in
                guard let id = notification.userInfo?[Self.ViewId] as? UUID else { return nil }
                return ViewNotification(id: id, name: name, userInfo: notification.userInfo)
            }
            .eraseToAnyPublisher()
    }
}
