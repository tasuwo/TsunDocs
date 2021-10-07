//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

/// @mockable
public protocol TsundocQueryService {
    func queryTsundoc(having id: Tsundoc.ID) -> Result<AnyObservedEntity<Tsundoc>, QueryServiceError>
    func queryTsundocs(tagged tagId: Tag.ID) -> Result<AnyObservedEntityArray<Tsundoc>, QueryServiceError>
    func queryAllTsundocs() -> Result<AnyObservedEntityArray<Tsundoc>, QueryServiceError>
}
