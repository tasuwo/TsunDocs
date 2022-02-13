//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//
//

import CoreData
import Foundation

public extension Tsundoc {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<Tsundoc> {
        return NSFetchRequest<Tsundoc>(entityName: "Tsundoc")
    }

    @NSManaged var createdDate: Date?
    @NSManaged var descriptionText: String?
    @NSManaged var emojiAlias: String?
    @NSManaged var id: UUID?
    @NSManaged var imageUrl: URL?
    @NSManaged var title: String?
    @NSManaged var updatedDate: Date?
    @NSManaged var url: URL?
    @NSManaged var emojiBackgroundColor: String?
    @NSManaged var tags: NSSet?
}

// MARK: Generated accessors for tags

public extension Tsundoc {
    @objc(addTagsObject:)
    @NSManaged func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged func removeFromTags(_ values: NSSet)
}

extension Tsundoc: Identifiable {
}
