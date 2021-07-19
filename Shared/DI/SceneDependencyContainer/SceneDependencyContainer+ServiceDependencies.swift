//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import UIKit

extension SceneDependencyContainer: HasPasteboard {
    // MARK: - HasPasteboard

    var pasteboard: Pasteboard { UIPasteboard.general }
}

extension SceneDependencyContainer: HasTsundocQueryService {
    // MARK: - HasTsundocQueryService

    var tsundocQueryService: TsundocQueryService { appDependencyContainer.tsundocQueryService }
}

extension SceneDependencyContainer: HasTagQueryService {
    // MARK: - HasTagQueryService

    var tagQueryService: TagQueryService { appDependencyContainer.tagQueryService }
}

extension SceneDependencyContainer: HasTsundocCommandService {
    // MARK: - HasTsundocCommandService

    var tsundocCommandService: TsundocCommandService { appDependencyContainer.tsundocCommandService }
}

extension SceneDependencyContainer: HasTagCommandService {
    // MARK: - HasTagCommandService

    var tagCommandService: TagCommandService { appDependencyContainer.tagCommandService }
}

extension SceneDependencyContainer: HasNop {}
