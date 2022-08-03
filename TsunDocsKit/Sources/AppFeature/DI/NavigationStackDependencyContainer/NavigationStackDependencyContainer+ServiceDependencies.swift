//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CoreDataCloudKitHelper
import Domain
import Environment
import MobileSettingFeature
import UIKit

extension NavigationStackDependencyContainer: DependencyContainer {
    // MARK: - DependencyContainer

    public var pasteboard: Pasteboard { UIPasteboard.general }
    public var tsundocQueryService: TsundocQueryService { container.tsundocQueryService }
    public var tagQueryService: TagQueryService { container.tagQueryService }
    public var tsundocCommandService: TsundocCommandService { container.tsundocCommandService }
    public var tagCommandService: TagCommandService { container.tagCommandService }
    public var userSettingStorage: UserSettingStorage { container.userSettingStorage }
    public var cloudKitAvailabilityObserver: CloudKitAvailabilityObservable { container.cloudKitAvailabilityObserver }
    public var webPageMetaResolver: WebPageMetaResolvable { container.webPageMetaResolver }
}
