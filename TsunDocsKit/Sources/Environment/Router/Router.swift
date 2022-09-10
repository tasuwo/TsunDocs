//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

public protocol Router {
    func push(_ route: any Route)
    func pop()
}
