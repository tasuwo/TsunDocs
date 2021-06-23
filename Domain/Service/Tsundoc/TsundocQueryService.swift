//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public protocol TsundocQueryService {
    func queryTsundoc(having id: Tsundoc.ID) -> Result<AnyObservedEntity<Tsundoc>, QueryServiceError>
    func queryAllTsundocs() -> Result<AnyObservedEntityArray<Tsundoc>, QueryServiceError>
}
