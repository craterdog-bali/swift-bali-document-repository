// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Repository",
    products: [
        .library(
            name: "Repository",
            targets: ["Repository"]),
    ],
    targets: [
        .target(
            name: "Repository",
            dependencies: []),
        .testTarget(
            name: "RepositoryTests",
            dependencies: ["Repository"]),
    ]
)
