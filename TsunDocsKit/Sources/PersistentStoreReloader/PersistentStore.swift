//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

public protocol PersistentStore {
    var isiCloudSyncEnabled: Bool { get }
    func reload(isiCloudSyncEnabled: Bool)
}
