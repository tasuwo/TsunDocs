//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

public protocol PersistentContainer {
    var isiCloudSyncEnabled: Bool { get }
    func reload(isiCloudSyncSettingEnabled: Bool)
}
