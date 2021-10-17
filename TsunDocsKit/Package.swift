// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "TsunDocs",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v15), .macOS(.v12)
    ],
    products: [
        .library(
            name: "CompositeKit",
            targets: ["CompositeKit"]
        ),
        .library(
            name: "Domain",
            targets: ["Domain"]
        ),
        .library(
            name: "Persistence",
            targets: ["Persistence"]
        ),
        .library(
            name: "MobileShareExtensionUIKit",
            targets: ["MobileShareExtensionUIKit"]
        ),
        .library(
            name: "TsunDocsUIKit",
            targets: ["TsunDocsUIKit"]
        ),
        .library(
            name: "TagKit",
            targets: ["TagKit"]
        ),
        .library(
            name: "EmojiKit",
            targets: ["EmojiKit"]
        ),
        .library(
            name: "TextEditAlert",
            targets: ["TextEditAlert"]
        ),
        .library(
            name: "SearchKit",
            targets: ["SearchKit"]
        ),
        .library(
            name: "PreviewContent",
            targets: ["PreviewContent"]
        ),
    ],
    dependencies: [
        .package(name: "Kanna",
                 url: "https://github.com/tid-kijyun/Kanna",
                 .upToNextMajor(from: "5.2.7")),
        .package(name: "Smile",
                 url: "https://github.com/onmyway133/Smile",
                 .upToNextMajor(from: "2.1.0"))
    ],
    targets: [
        .target(
            name: "CompositeKit",
            dependencies: []
        ),
        .target(
            name: "Domain",
            dependencies: ["Kanna", "Smile"]
        ),
        .target(
            name: "Persistence",
            dependencies: ["Domain"]
        ),
        .target(
            name: "TsunDocsUIKit",
            dependencies: ["Domain", "CompositeKit", "PreviewContent"]
        ),
        .target(
            name: "TagKit",
            dependencies: [
                "TextEditAlert",
                "SearchKit"
            ]
        ),
        .target(
            name: "EmojiKit",
            dependencies: [
                "SearchKit",
                .product(name: "Smile", package: "Smile")
            ]
        ),
        .target(
            name: "TextEditAlert",
            dependencies: ["CompositeKit"]
        ),
        .target(
            name: "SearchKit",
            dependencies: ["CompositeKit"]
        ),
        .target(
            name: "MobileShareExtensionUIKit",
            dependencies: [
                "Domain",
                "CompositeKit",
                "TsunDocsUIKit",
                "PreviewContent"
            ]
        ),
        .target(
            name: "PreviewContent",
            dependencies: ["Domain", "CompositeKit"]
        ),
    ]
)
