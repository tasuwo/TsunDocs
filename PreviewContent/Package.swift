// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "PreviewContent",
    platforms: [
        .iOS(.v15), .macOS(.v11)
    ],
    products: [
        .library(
            name: "PreviewContent",
            targets: ["PreviewContent"]
        ),
    ],
    dependencies: [
        .package(name: "Domain", path: "./Domain"),
        .package(name: "CompositeKit", path: "./CompositeKit")
    ],
    targets: [
        .target(
            name: "PreviewContent",
            dependencies: ["Domain", "CompositeKit"]
        ),
    ]
)
