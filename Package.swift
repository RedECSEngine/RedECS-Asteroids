// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RedECS-Asteroids",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
        .tvOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Asteroids",
            targets: ["Asteroids"]
        ),
        .library(
            name: "SpriteKitSupport",
            targets: ["SpriteKitSupport"]
        ),
        .executable(name: "WebSupport", targets: ["WebSupport"])
    ],
    dependencies: [
        .package(name: "RedECS", url: "https://github.com/RedECSEngine/RedECS.git", from: "0.0.2"),
        .package(name: "swift-numerics", url: "https://github.com/apple/swift-numerics.git", from: "0.0.1"),
        .package(name: "JavaScriptKit", url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.13.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Asteroids",
            dependencies: [
                .product(name: "RedECS", package: "RedECS"),
                .product(name: "RedECSBasicComponents", package: "RedECS"),
                .product(name: "RedECSRenderingComponents", package: "RedECS"),
                .product(name: "RealModule", package: "swift-numerics")
            ]
        ),
        .target(
            name: "SpriteKitSupport",
            dependencies: [
                "Asteroids",
                .product(name: "RedECSSpriteKitSupport", package: "RedECS"),
            ]
        ),
        .target(
            name: "WebSupport",
            dependencies: [
                "Asteroids",
                .product(name: "RedECSWebSupport", package: "RedECS"),
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
            ],
            resources: [
                .copy("Resources")
            ]
        ),
        .testTarget(
            name: "AsteroidsTests",
            dependencies: ["Asteroids"]
        ),
    ]
)
