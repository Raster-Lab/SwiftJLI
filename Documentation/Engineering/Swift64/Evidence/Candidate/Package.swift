// swift-tools-version: 6.4
// SPDX-License-Identifier: MIT
import PackageDescription

let package = Package(
    name: "SwiftJLI",
    platforms: [
        .macOS("26.0"), .iOS("26.0"), .tvOS("26.0"),
        .watchOS("26.0"), .visionOS("26.0")
    ],
    products: [.library(name: "SwiftJLI", targets: ["SwiftJLI"])],
    targets: [
        .target(name: "SwiftJLI"),
        .testTarget(name: "SwiftJLITests", dependencies: ["SwiftJLI"])
    ],
    swiftLanguageModes: [.v6]
)
