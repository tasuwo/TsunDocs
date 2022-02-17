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
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
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
            name: "MobileShareExtensionFeature",
            targets: ["MobileShareExtensionFeature"]
        ),
        .library(
            name: "MobileShareExtensionUIKit",
            targets: ["MobileShareExtensionUIKit"]
        ),
        .library(
            name: "TsundocList",
            targets: ["TsundocList"]
        ),
        .library(
            name: "TagKit",
            targets: ["TagKit"]
        ),
        .library(
            name: "EmojiList",
            targets: ["EmojiList"]
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
            name: "ImageLoader",
            targets: ["ImageLoader"]
        ),
        .library(
            name: "ButtonStyle",
            targets: ["ButtonStyle"]
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
                 .upToNextMajor(from: "2.1.0")),
        .package(name: "Nuke",
                 url: "https://github.com/kean/Nuke",
                 .upToNextMajor(from: "10.7.1"))
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "ButtonStyle",
                "CompositeKit",
                "Domain",
                "EmojiList",
                "Persistence",
                "SearchKit",
                "TagKit",
                "TsundocList"
            ]
        ),
        .target(
            name: "MobileShareExtensionFeature",
            dependencies: [
                "Persistence",
                "MobileShareExtensionUIKit",
            ]
        ),
        .target(
            name: "MobileShareExtensionUIKit",
            dependencies: [
                "Domain",
                "CompositeKit",
                "TsundocList",
                "PreviewContent"
            ]
        ),
        .target(
            name: "Domain",
            dependencies: [
                .product(name: "Kanna", package: "Kanna"),
                .product(name: "Smile", package: "Smile"),
                "SearchKit"
            ]
        ),
        .target(
            name: "Persistence",
            dependencies: ["Domain"]
        ),
        .target(
            name: "TsundocList",
            dependencies: [
                "TagKit",
                "EmojiList",
                "ImageLoader",
                "TextEditAlert",
                "ButtonStyle"
            ]
        ),
        .target(
            name: "TagKit",
            dependencies: [
                "TextEditAlert",
                "SearchKit",
                "Domain",
                "PreviewContent"
            ]
        ),
        .target(
            name: "EmojiList",
            dependencies: [
                "SearchKit",
                "Domain"
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
            name: "ImageLoader",
            dependencies: [
                .product(name: "Nuke", package: "Nuke"),
            ]
        ),
        .target(
            name: "ButtonStyle",
            dependencies: []
        ),
        .target(
            name: "CompositeKit",
            dependencies: []
        ),
        .target(
            name: "PreviewContent",
            dependencies: ["Domain", "CompositeKit"]
        ),
    ]
)
