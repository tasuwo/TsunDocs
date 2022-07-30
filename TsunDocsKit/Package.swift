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
            name: "BrowseView",
            targets: ["BrowseView"]
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
            name: "Environment",
            targets: ["Environment"]
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
            name: "TsundocCreateFeature",
            targets: ["TsundocCreateFeature"]
        ),
        .library(
            name: "TsundocList",
            targets: ["TsundocList"]
        ),
        .library(
            name: "TsundocListFeature",
            targets: ["TsundocListFeature"]
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
            name: "UIComponent",
            targets: ["UIComponent"]
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
            name: "CoreDataCloudKitSupport",
            targets: ["CoreDataCloudKitSupport"]
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
                "CompositeKit",
                "Domain",
                "Environment",
                "EmojiList",
                "Persistence",
                "SearchKit",
                "TagKit",
                "TsundocList",
                "TsundocListFeature",
                "TsundocCreateFeature",
                "UIComponent",
                "CoreDataCloudKitSupport"
            ]
        ),
        .target(
            name: "BrowseView",
            dependencies: [
                "UIComponent",
            ]
        ),
        .target(
            name: "MobileShareExtensionFeature",
            dependencies: [
                "Environment",
                "Persistence",
                "TsundocCreateFeature",
            ]
        ),
        .target(
            name: "TsundocCreateFeature",
            dependencies: [
                "Domain",
                "CompositeKit",
                "TsundocList",
                "PreviewContent"
            ]
        ),
        .target(
            name: "TsundocListFeature",
            dependencies: [
                "BrowseView",
                "CompositeKit",
                "Domain",
                "Environment",
                "TsundocList",
                "UIComponent",
                "ImageLoader",
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
            name: "Environment",
            dependencies: [
                "CompositeKit",
                "Domain"
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
                "UIComponent"
            ]
        ),
        .target(
            name: "TagKit",
            dependencies: [
                "SearchKit",
                "Domain",
                "Environment",
                "PreviewContent",
                "UIComponent"
            ]
        ),
        .target(
            name: "UIComponent",
            dependencies: [
                "CompositeKit"
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
            name: "CompositeKit",
            dependencies: []
        ),
        .target(
            name: "CoreDataCloudKitSupport",
            dependencies: []
        ),
        .target(
            name: "PreviewContent",
            dependencies: [
                "CompositeKit",
                "CoreDataCloudKitSupport",
                "Domain",
                "Environment"
            ]
        ),
    ]
)
