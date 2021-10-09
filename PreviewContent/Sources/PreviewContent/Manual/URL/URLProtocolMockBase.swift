//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation
import SwiftUI

open class URLProtocolMockBase: URLProtocol {
    open class var mock_delay: TimeInterval? { return nil }
    open class var mock_handler: ((URLRequest) throws -> (HTTPURLResponse, Data?))? { return nil }

    // MARK: - Metnods

    private func handle() {
        guard let handler = type(of: self).mock_handler else {
            fatalError("URLProtocolMock handler is unavailable.")
        }

        do {
            let (response, data) = try handler(self.request)

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }

            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    // MARK: - URLProtocol (overrides)

    override open class func canInit(with task: URLSessionTask) -> Bool { true }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override open func startLoading() {
        if let delay = Self.mock_delay {
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) { self.handle() }
        } else {
            handle()
        }
    }

    override open func stopLoading() {}
}
