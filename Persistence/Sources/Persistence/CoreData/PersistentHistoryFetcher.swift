//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreData

enum PersistentHistoryFetcher {
    enum Error: Swift.Error {
        case failedToConvertHistoryTransaction
    }

    // MARK: - Methods

    static func fetch(after lastHistoryToken: NSPersistentHistoryToken?,
                      with context: NSManagedObjectContext) throws -> [NSPersistentHistoryTransaction]
    {
        let request = fetchRequest(after: lastHistoryToken, with: context)

        guard let result = try context.execute(request) as? NSPersistentHistoryResult,
              let transactions = result.result as? [NSPersistentHistoryTransaction]
        else {
            throw Error.failedToConvertHistoryTransaction
        }

        return transactions
    }

    private static func fetchRequest(after lastHistoryToken: NSPersistentHistoryToken?,
                                     with context: NSManagedObjectContext) -> NSPersistentHistoryChangeRequest
    {
        let request = NSPersistentHistoryChangeRequest.fetchHistory(after: lastHistoryToken)

        guard let fetchRequest = NSPersistentHistoryTransaction.fetchRequest else {
            return request
        }

        var predicates: [NSPredicate] = []
        if let author = context.transactionAuthor {
            predicates.append(NSPredicate(format: "%K != %@",
                                          #keyPath(NSPersistentHistoryTransaction.author),
                                          author))
        }
        if let contextName = context.name {
            predicates.append(NSPredicate(format: "%K != %@",
                                          #keyPath(NSPersistentHistoryTransaction.contextName),
                                          contextName))
        }
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        request.fetchRequest = fetchRequest

        return request
    }
}
