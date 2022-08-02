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
            name: "TagMultiSelectionFeature",
            targets: ["TagMultiSelectionFeature"]
        ),
        .library(
            name: "UIComponent",
            targets: ["UIComponent"]
        ),
        .library(
            name: "ImageLoader",
            targets: ["ImageLoader"]
        ),
        .library(
            name: "CoreDataCloudKitHelper",
            targets: ["CoreDataCloudKitHelper"]
        ),
        .library(
            name: "PreviewContent",
            targets: ["PreviewContent"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/tid-kijyun/Kanna", .upToNextMajor(from: "5.2.7")),
        .package(url: "https://github.com/onmyway133/Smile", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/kean/Nuke", .upToNextMajor(from: "10.7.1"))
    ],
    targets: [
        /// App

        .target(
            name: "AppFeature",
            dependencies: [
                "CompositeKit",
                "CoreDataCloudKitHelper",
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
            ]
        ),
        .target(
            name: "MobileShareExtensionFeature",
            dependencies: [
                "Environment",
                "Persistence",
                "TagMultiSelectionFeature",
                "TsundocCreateFeature",
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
                "ImageLoader",
            ]
        ),
        .target(
            name: "TagListFeature",
            dependencies: [
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
                "CoreDataCloudKitHelper"
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
                "ImageLoader",
            ]
        ),

        /// Helper

        .target(
            name: "ImageLoader",
            dependencies: [.product(name: "Nuke", package: "Nuke")]
        ),
        .target(name: "CompositeKit"),
        .target(name: "CoreDataCloudKitHelper"),
        .target(
            name: "PreviewContent",
            dependencies: [
                "CompositeKit",
                "CoreDataCloudKitHelper",
                "Domain",
                "Environment"
            ]
        ),
    ]
)
