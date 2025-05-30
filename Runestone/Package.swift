// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Runestone",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "Runestone", targets: ["Runestone"]),
        .library(name: "RunestoneTesting", targets: ["RunestoneTesting"])
    ],
    dependencies: [
        .package(url: "https://github.com/tree-sitter/tree-sitter", .upToNextMinor(from: "0.20.9"))
    ],
    targets: [

        .target(
            name: "Runestone",
            dependencies: [
                .product(name: "TreeSitter", package: "tree-sitter")
            ],
            swiftSettings: [
                .define("ENABLE_TESTABILITY"),
                .unsafeFlags(["-enable-testing"])
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
                .process("TextView/Appearance/Theme.xcassets")
            ]
        ),

        .target(
            name: "TestTreeSitterLanguages",
            cSettings: [
                .unsafeFlags(["-w"])
            ]
        ),

        .testTarget(
            name: "RunestoneTests",
            dependencies: [
                "RunestoneTesting",
                "TestTreeSitterLanguages"
            ]
        )
    ]
)