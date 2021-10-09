// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Persistence",
    platforms: [
        .iOS(.v15), .macOS(.v11)
    ],
    products: [
        .library(
            name: "Persistence",
            targets: ["Persistence"]
        )
    ],
    dependencies: [
        .package(name: "Domain", path: "./Domain")
    ],
    targets: [
        .target(
            name: "Persistence",
            dependencies: ["Domain"]
        ),
        .testTarget(
            name: "PersistenceTests",
            dependencies: ["Persistence"]
        )
    ]
)
