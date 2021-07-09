//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

public protocol HasSharedUrlLoader {
    var sharedUrlLoader: SharedUrlLoadable { get }
}

public protocol HasWebPageMetaResolver {
    var webPageMetaResolver: WebPageMetaResolvable { get }
}

public protocol HasTsundocCommandService {
    var tsundocCommandService: TsundocCommandService { get }
}

public protocol HasCompletable {
    var completable: Completable { get }
}

public protocol HasNop {}
