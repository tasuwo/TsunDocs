//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData

public protocol ViewContextObserving: AnyObject {
    func didReplaced(context: NSManagedObjectContext)
}
