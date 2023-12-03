//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Domain
import Environment
import MobileSettingFeature
import UIKit

public typealias DependencyContainer = HasCloudKitAvailabilityObserver
    & HasNop
    & HasPasteboard
    & HasSharedUserSettingStorage
    & HasTagCommandService
    & HasTagQueryService
    & HasTsundocCommandService
    & HasTsundocQueryService
    & HasUserSettingStorage
    & HasWebPageMetaResolver
