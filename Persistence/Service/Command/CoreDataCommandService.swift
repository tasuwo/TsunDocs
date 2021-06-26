//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData
import Domain

public class CoreDataCommandService {
    // MARK: - Properties

    public var context: NSManagedObjectContext {
        willSet {
            context.perform { [weak self] in
                guard let self = self else { return }
                if self.context.hasChanges {
                    self.context.rollback()
                }
            }
        }
    }

    // MARK: - Initializers

    public init(_ context: NSManagedObjectContext) {
        self.context = context
    }
}

extension CoreDataCommandService: Transaction {
    public func perform(_ block: @escaping () -> Void) {
        context.performAndWait(block)
    }

    public func begin() throws {
        context.reset()
    }

    public func commit() throws {
        try context.save()
    }

    public func cancel() throws {
        context.rollback()
    }
}
