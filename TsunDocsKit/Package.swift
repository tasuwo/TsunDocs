// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "TsunDocs",
    defaultLocalization: "ja",
    platforms: [
        .iOS("16"), .macOS(.v12)
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
            name: "TsundocInfoFeature",
            targets: ["TsundocInfoFeature"]
        ),
        .library(
            name: "TsundocListFeature",
            targets: ["TsundocListFeature"]
        ),
        .library(
            name: "TagListFeature",
            targets: ["TagListFeature"]
        ),
        .library(
            name: "TagMultiSelectionFeature",
            targets: ["TagMultiSelectionFeature"]
        ),
        .library(
            name: "MobileSettingFeature",
            targets: ["MobileSettingFeature"]
        ),
        .library(
            name: "UIComponent",
            targets: ["UIComponent"]
        ),
        .library(
            name: "PreviewContent",
            targets: ["PreviewContent"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/tasuwo/swift", .upToNextMajor(from: "0.6.0")),
        .package(url: "https://github.com/tid-kijyun/Kanna", .upToNextMajor(from: "5.2.7")),
        .package(url: "https://github.com/onmyway133/Smile", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/kean/Nuke", .upToNextMajor(from: "12.2.0")),
        .package(url: "https://github.com/tasuwo/PersistentStack", .upToNextMajor(from: "0.6.0")),
        .package(url: "https://github.com/tasuwo/SplitView", .upToNextMinor(from: "0.1.0"))
    ],
    targets: [
        /// App

        .target(
            name: "AppFeature",
            dependencies: [
                "CompositeKit",
                "Domain",
                "Environment",
                "Persistence",
                "TagListFeature",
                "TagMultiSelectionFeature",
                "TsundocListFeature",
                "TsundocInfoFeature",
                "TsundocCreateFeature",
                "MobileSettingFeature",
                "UIComponent",
                .product(name: "PersistentStack", package: "PersistentStack"),
                .product(name: "SplitView", package: "SplitView")
            ]
        ),
        .target(
            name: "MobileShareExtensionFeature",
            dependencies: [
                "Environment",
                "Persistence",
                "TagMultiSelectionFeature",
                "TsundocCreateFeature",
                .product(name: "PersistentStack", package: "PersistentStack")
            ]
        ),

        /// Feature

        .target(
            name: "TsundocCreateFeature",
            dependencies: [
                "CompositeKit",
                "Domain",
                "Environment",
                "PreviewContent",
                "UIComponent",
            ]
        ),
        .target(
            name: "TsundocInfoFeature",
            dependencies: [
                "BrowseView",
                "CompositeKit",
                "Domain",
                "Environment",
                "PreviewContent",
                "UIComponent",
            ]
        ),
        .target(
            name: "TsundocListFeature",
            dependencies: [
                "BrowseView",
                "CompositeKit",
                "Domain",
                "Environment",
                "PreviewContent",
                "UIComponent",
                .product(name: "NukeUI", package: "Nuke"),
            ]
        ),
        .target(
            name: "TagListFeature",
            dependencies: [
                "TagMultiSelectionFeature",
                "CompositeKit",
                "Domain",
                "Environment",
                "PreviewContent",
                "UIComponent"
            ]
        ),
        .target(
            name: "TagMultiSelectionFeature",
            dependencies: [
                "CompositeKit",
                "Domain",
                "Environment",
                "PreviewContent",
                "UIComponent"
            ]
        ),
        .target(
            name: "MobileSettingFeature",
            dependencies: [
                "CompositeKit",
                "Domain",
                "Environment",
                "PreviewContent",
                "UIComponent",
            ]
        ),

        /// Core

        .target(
            name: "Domain",
            dependencies: [
                "CompositeKit",
                .product(name: "Kanna", package: "Kanna"),
                .product(name: "Smile", package: "Smile"),
            ]
        ),
        .target(
            name: "Environment",
            dependencies: [
                "CompositeKit",
                "Domain"
            ]
        ),

        /// Presistence

        .target(
            name: "Persistence",
            dependencies: ["Domain"]
        ),

        /// UI

        .target(
            name: "BrowseView",
            dependencies: [
                "UIComponent",
            ]
        ),
        .target(
            name: "UIComponent",
            dependencies: [
                "CompositeKit",
                "Domain",
                .product(name: "NukeUI", package: "Nuke"),
            ]
        ),

        /// Helper

        .target(name: "CompositeKit"),
        .target(
            name: "PreviewContent",
            dependencies: [
                "CompositeKit",
                "Domain",
                "Environment"
            ]
        ),
    ]
)
