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
        // ✅ Safe version for use in your app
        .target(
            name: "Runestone",
            dependencies: [
                .product(name: "TreeSitter", package: "tree-sitter")
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
                .process("TextView/Appearance/Theme.xcassets")
            ]
        ),

        // ✅ Testing version only — not linked in your app
        .target(
            name: "RunestoneTesting",
            dependencies: ["Runestone"],
            swiftSettings: [
                .define("ENABLE_TESTABILITY"),
                .unsafeFlags(["-enable-testing"])
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