//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

private class BundleFinder {}

extension Foundation.Bundle {
    static let moduleName = "SaveUrlFeature"

    static var this: Bundle = {
        let bundleName = "TsunDocs_\(moduleName)"

        let candidates = [
            // App にリンクされた場合
            Bundle.main.resourceURL,
            // Framework にリンクされた場合
            Bundle(for: BundleFinder.self).resourceURL,
            /// CLI ツールにリンクされた場合
            Bundle.main.bundleURL,
            /// 別パッケージからプレビューを起動された場合
            Bundle(for: BundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent(),
            Bundle(for: BundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent(),
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }

        fatalError("unable to find bundle")
    }()
}
