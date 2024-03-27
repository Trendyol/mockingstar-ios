// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MockingStar",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "MockingStar",
            targets: ["MockingStar"]),
    ],
    targets: [
        .target(
            name: "MockingStar")
    ]
)
