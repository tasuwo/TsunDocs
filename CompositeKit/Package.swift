// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "CompositeKit",
    platforms: [
        .iOS(.v15), .macOS(.v11)
    ],
    products: [
        .library(
            name: "CompositeKit",
            targets: ["CompositeKit"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CompositeKit",
            dependencies: []
        ),
        .testTarget(
            name: "CompositeKitTests",
            dependencies: ["CompositeKit"]
        )
    ]
)
