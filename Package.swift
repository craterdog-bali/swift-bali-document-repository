// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Repository",
    products: [
        .library(
            name: "Repository",
            targets: ["Repository"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-aws/aws-sdk-swift", .upToNextMinor(from: "4.0.0"))
    ],
    targets: [
        .target(
            name: "Repository",
            dependencies: ["S3", "IAM", "CognitoIdentity"]),
        .testTarget(
            name: "RepositoryTests",
            dependencies: ["Repository"]),
    ]
)
