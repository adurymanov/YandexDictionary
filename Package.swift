// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YandexDictionary",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "YandexDictionary",
            targets: ["YandexDictionary"]),
    ],
    targets: [
        .target(
            name: "YandexDictionary"),
        .testTarget(
            name: "YandexDictionaryTests",
            dependencies: ["YandexDictionary"]),
    ]
)
