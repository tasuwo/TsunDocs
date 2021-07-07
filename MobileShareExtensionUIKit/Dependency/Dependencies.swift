//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

protocol HasSharedUrlLoader {
    var sharedUrlLoader: SharedUrlLoadable { get }
}

protocol HasWebPageMetaResolver {
    var webPageMetaResolver: WebPageMetaResolvable { get }
}

protocol HasTsundocCommandService {
    var tsundocCommandService: TsundocCommandService { get }
}

protocol HasCompletable {
    var completable: Completable { get }
}
