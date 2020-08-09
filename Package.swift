// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReactiveKitCoreData",
    platforms: [
        .iOS( .v9 ),
        .macOS( .v10_14)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ReactiveKitCoreData",
            targets: ["ReactiveKitCoreData"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/DeclarativeHub/ReactiveKit.git", from: "3.10.0"),
        .package(url: "https://github.com/DeclarativeHub/Bond", from: "7.4.1"),
        .package(url: "https://github.com/Brightify/Cuckoo.git", .upToNextMajor(from: "1.3.0")),
        .package(url: "https://github.com/dmytro-anokhin/core-data-model-description", from: "0.0.1"),
        .package(url: "https://github.com/Quick/Quick", from: "1.3.2"),
        .package(url: "https://github.com/Quick/Nimble", from: "7.3.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ReactiveKitCoreData",
            dependencies:["ReactiveKit", "Bond"]),
        .testTarget(
            name: "ReactiveKitCoreDataTests",
            dependencies: ["ReactiveKitCoreData", "Cuckoo", "CoreDataModelDescription", "Quick", "Nimble"]),
    ]
)
