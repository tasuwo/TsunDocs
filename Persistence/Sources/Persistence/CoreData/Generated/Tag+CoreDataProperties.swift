//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//
//

import CoreData
import Foundation

public extension Tag {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged var createdDate: Date?
    @NSManaged var id: UUID?
    @NSManaged var name: String?
    @NSManaged var tsundocsCount: Int64
    @NSManaged var updatedDate: Date?
    @NSManaged var tsundocs: NSSet?
}

// MARK: Generated accessors for tsundocs

public extension Tag {
    @objc(addTsundocsObject:)
    @NSManaged func addToTsundocs(_ value: Tsundoc)

    @objc(removeTsundocsObject:)
    @NSManaged func removeFromTsundocs(_ value: Tsundoc)

    @objc(addTsundocs:)
    @NSManaged func addToTsundocs(_ values: NSSet)

    @objc(removeTsundocs:)
    @NSManaged func removeFromTsundocs(_ values: NSSet)
}

extension Tag: Identifiable {
}
