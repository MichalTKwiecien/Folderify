// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "World",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "World",
            targets: ["World"]),
    ],
    dependencies: [
        .package(name: "Prelude", path: "../Prelude"),
        .package(name: "Networking", path: "../Networking")
    ],
    targets: [
        .target(
            name: "World",
            dependencies: ["Prelude", "Networking"]),
    ]
)
