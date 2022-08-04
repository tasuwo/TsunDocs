//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

public enum TsundocListQuery: Equatable, Hashable {
    case all
    case tagged(Tag.ID)
}
