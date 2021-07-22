//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

/// @mockable
public protocol TagQueryService {
    func fetchTags(taggedToTsundocHaving id: Tsundoc.ID) -> Result<Set<Tag>, QueryServiceError>
    func queryTag(having id: Tag.ID) -> Result<AnyObservedEntity<Tag>, QueryServiceError>
    func queryAllTags() -> Result<AnyObservedEntityArray<Tag>, QueryServiceError>
}
