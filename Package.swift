// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "STTextKitPlus",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "STTextKitPlus",
            targets: ["STTextKitPlus"]
        ),
    ],
    targets: [
        .target(
            name: "STTextKitPlus"
        )
    ]
)
