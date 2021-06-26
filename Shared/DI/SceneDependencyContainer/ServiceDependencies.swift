//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

/// @mockable
protocol HasTsundocQueryService {
    var tsundocQueryService: TsundocQueryService { get }
}

/// @mockable
protocol HasTagQueryService {
    var tagQueryService: TagQueryService { get }
}

/// @mockable
protocol HasTsundocCommandService {
    var tsundocCommandService: TsundocCommandService { get }
}

/// @mockable
protocol HasTagCommandService {
    var tagCommandService: TagCommandService { get }
}
