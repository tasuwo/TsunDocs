// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TsunDocs",
    defaultLocalization: "ja",
    platforms: [
        .iOS("16"), .macOS(.v13)
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
        .package(url: "https://github.com/tasuwo/swift", .upToNextMajor(from: "0.8.0")),
        .package(url: "https://github.com/tid-kijyun/Kanna", .upToNextMajor(from: "5.2.7")),
        .package(url: "https://github.com/onmyway133/Smile", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/kean/Nuke", .upToNextMajor(from: "12.2.0")),
        .package(url: "https://github.com/tasuwo/PersistentStack", .upToNextMajor(from: "0.6.0")),
        .package(url: "https://github.com/tasuwo/SplitView", .upToNextMinor(from: "0.1.1"))
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
            ],
            plugins: [
                .plugin(name: "LintSwift", package: "swift")
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
            ],
            plugins: [
                .plugin(name: "LintSwift", package: "swift")
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
            ],
            plugins: [
                .plugin(name: "LintSwift", package: "swift")
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
            ],
            plugins: [
                .plugin(name: "LintSwift", package: "swift")
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
            ],
            plugins: [
                .plugin(name: "LintSwift", package: "swift")
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
            ],
            plugins: [
                .plugin(name: "LintSwift", package: "swift")
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
            ],
            plugins: [
                .plugin(name: "LintSwift", package: "swift")
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
            ],
            plugins: [
                .plugin(name: "LintSwift", package: "swift")
            ]
        ),

        /// Core

        .target(
            name: "Domain",
            dependencies: [
                "CompositeKit",
                .product(name: "Kanna", package: "Kanna"),
                .product(name: "Smile", package: "Smile"),
            ],
            plugins: [
                .plugin(name: "LintSwift", package: "swift")
            ]
        ),
        .target(
            name: "Environment",
            dependencies: [
                "CompositeKit",
                "Domain"
            ],
            plugins: [
                .plugin(name: "LintSwift", package: "swift")
            ]
        ),

        /// Presistence

        .target(
            name: "Persistence",
            dependencies: ["Domain"],
            plugins: [
                .plugin(name: "LintSwift", package: "swift")
            ]
        ),

        /// UI

        .target(
            name: "BrowseView",
            dependencies: [
                "UIComponent",
            ],
            plugins: [
                .plugin(name: "LintSwift", package: "swift")
            ]
        ),
        .target(
            name: "UIComponent",
            dependencies: [
                "CompositeKit",
                "Domain",
                .product(name: "NukeUI", package: "Nuke"),
            ],
            plugins: [
                .plugin(name: "LintSwift", package: "swift")
            ]
        ),

        /// Helper

        .target(
            name: "CompositeKit",
            plugins: [
                .plugin(name: "LintSwift", package: "swift")
            ]
        ),
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
