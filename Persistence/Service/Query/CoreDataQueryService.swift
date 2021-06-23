//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain

public class CoreDataQueryService {
    // MARK: - Properties

    public var context: NSManagedObjectContext {
        didSet {
            observers.forEach { $0.didReplaced(context: context) }
        }
    }

    private var observers: WeakContainerArray<ViewContextObserving> = .init()

    // MARK: - Initializers

    public init(_ context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Methods

    func append(_ observer: ViewContextObserving) {
        observers.append(observer)
    }
}
