// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "MobileShareExtensionUIKit",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v15), .macOS(.v11)
    ],
    products: [
        .library(
            name: "MobileShareExtensionUIKit",
            targets: ["MobileShareExtensionUIKit"]
        )
    ],
    dependencies: [
        .package(name: "Domain", path: "./Domain"),
        .package(name: "CompositeKit", path: "./CompositeKit"),
        .package(name: "TsunDocsUIKit", path: "./TsunDocsUIKit"),
        .package(name: "PreviewContent", path: "./PreviewContent")
    ],
    targets: [
        .target(
            name: "MobileShareExtensionUIKit",
            dependencies: [
                "Domain",
                "CompositeKit",
                "TsunDocsUIKit",
                "PreviewContent"
            ]
        ),
        .testTarget(
            name: "MobileShareExtensionUIKitTests",
            dependencies: ["MobileShareExtensionUIKit"]
        )
    ]
)
