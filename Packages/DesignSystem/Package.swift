// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]),
    ],
    dependencies: [
        .package(name: "Prelude", path: "../Prelude")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: ["Prelude"]),
    ]
)
