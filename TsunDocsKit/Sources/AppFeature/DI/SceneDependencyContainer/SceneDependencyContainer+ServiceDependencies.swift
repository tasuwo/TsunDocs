//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreDataCloudKitHelper
import Domain
import Environment
import MobileSettingFeature
import UIKit

extension SceneDependencyContainer: HasPasteboard {
    // MARK: - HasPasteboard

    public var pasteboard: Pasteboard { UIPasteboard.general }
}

extension SceneDependencyContainer: HasTsundocQueryService {
    // MARK: - HasTsundocQueryService

    public var tsundocQueryService: TsundocQueryService { appDependencyContainer.tsundocQueryService }
}

extension SceneDependencyContainer: HasTagQueryService {
    // MARK: - HasTagQueryService

    public var tagQueryService: TagQueryService { appDependencyContainer.tagQueryService }
}

extension SceneDependencyContainer: HasTsundocCommandService {
    // MARK: - HasTsundocCommandService

    public var tsundocCommandService: TsundocCommandService { appDependencyContainer.tsundocCommandService }
}

extension SceneDependencyContainer: HasTagCommandService {
    // MARK: - HasTagCommandService

    public var tagCommandService: TagCommandService { appDependencyContainer.tagCommandService }
}

extension SceneDependencyContainer: HasUserSettingStorage {
    // MARK: - HasUserSettingStorage

    public var userSettingStorage: UserSettingStorage { appDependencyContainer.userSettingStorage }
}

extension SceneDependencyContainer: HasCloudKitAvailabilityObserver {
    // MARK: - HasCloudKitAvailabilityObserver

    public var cloudKitAvailabilityObserver: CloudKitAvailabilityObservable { appDependencyContainer.cloudKitAvailabilityObserver }
}

extension SceneDependencyContainer: HasWebPageMetaResolver {
    // MARK: - HasWebPageMetaResolver

    public var webPageMetaResolver: WebPageMetaResolvable { appDependencyContainer.webPageMetaResolver }
}

extension SceneDependencyContainer: HasNop {}
