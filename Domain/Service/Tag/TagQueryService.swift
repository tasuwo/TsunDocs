//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public protocol TagQueryService {
    func queryTag(having id: Tag.ID) -> Result<AnyObservedEntity<Tag>, QueryServiceError>
    func queryAllTags() -> Result<AnyObservedEntityArray<Tag>, QueryServiceError>
}
