// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Runestone",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Runestone",
            targets: ["Runestone"]
        )
    ],
    targets: [
        .target(
            name: "Runestone",
            path: "Sources"
        )
    ]
)
