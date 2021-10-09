// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "TsunDocsUIKit",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v15), .macOS(.v11)
    ],
    products: [
        .library(
            name: "TsunDocsUIKit",
            targets: ["TsunDocsUIKit"]
        ),
    ],
    dependencies: [
        .package(name: "Domain", path: "./Domain"),
        .package(name: "CompositeKit", path: "./CompositeKit"),
        .package(name: "PreviewContent", path: "./PreviewContent")
    ],
    targets: [
        .target(
            name: "TsunDocsUIKit",
            dependencies: ["Domain", "CompositeKit", "PreviewContent"]
        ),
        .testTarget(
            name: "TsunDocsUIKitTests",
            dependencies: ["TsunDocsUIKit"]
        )
    ]
)
