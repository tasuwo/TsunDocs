//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

extension URLSession {
    static func makeMock(_ urlProtocol: URLProtocol.Type) -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [urlProtocol]
        return URLSession(configuration: configuration)
    }
}
