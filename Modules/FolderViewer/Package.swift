// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FolderViewer",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "FolderViewer",
            targets: ["FolderViewer"]),
    ],
    dependencies: [
        .package(name: "Prelude", path: "../Prelude"),
        .package(name: "World", path: "../World"),
        .package(name: "DesignSystem", path: "../DesignSystem"),
        .package(name: "Architecture", path: "../Architecture")
    ],
    targets: [
        .target(
            name: "FolderViewer",
            dependencies: ["Prelude", "World", "DesignSystem", "Architecture"]),
    ]
)
