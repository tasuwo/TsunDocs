// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [
        .iOS(.v15), .macOS(.v11)
    ],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]
        )
    ],
    dependencies: [
        .package(name: "Kanna",
                 url: "https://github.com/tid-kijyun/Kanna",
                 .upToNextMajor(from: "5.2.7")),
        .package(name: "Smile",
                 url: "https://github.com/onmyway133/Smile",
                 .upToNextMajor(from: "2.1.0"))
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: ["Kanna", "Smile"]
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"]
        )
    ]
)
