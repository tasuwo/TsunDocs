//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

protocol HasTsundocQueryService {
    var tsundocQueryService: TsundocQueryService { get }
}

protocol HasTagQueryService {
    var tagQueryService: TagQueryService { get }
}

protocol HasTsundocCommandService {
    var tsundocCommandService: TsundocCommandService { get }
}

protocol HasTagCommandService {
    var tagCommandService: TagCommandService { get }
}
