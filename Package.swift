// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Repository",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "Repository",
            targets: ["Repository"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/craterdog-bali/swift-bali-document-notation", from: "2.0.3")
    ],
    targets: [
        .target(
            name: "Repository",
            dependencies: ["BDN"]
        ),
        .testTarget(
            name: "RepositoryTests",
            dependencies: ["BDN", "Repository"]
        )
    ]
)
