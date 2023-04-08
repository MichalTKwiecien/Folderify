// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Architecture",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Architecture",
            targets: ["Architecture"]),
    ],
    dependencies: [
        .package(name: "Prelude", path: "../Prelude")
    ],
    targets: [
        .target(
            name: "Architecture",
            dependencies: ["Prelude"]),
    ]
)
