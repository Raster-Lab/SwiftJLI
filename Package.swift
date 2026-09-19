// swift-tools-version: 6.4
// SPDX-License-Identifier: MIT
import PackageDescription

let package = Package(
    name: "SwiftJLI",
    platforms: [
        .macOS("27.0"), .iOS("27.0"), .tvOS("27.0"),
        .watchOS("27.0"), .visionOS("27.0")
    ],
    products: [.library(name: "SwiftJLI", targets: ["SwiftJLI"]),
               .executable(name: "swiftjli", targets: ["SwiftJLICLI"])],
    targets: [
        .target(name: "SwiftJLI"),
        .executableTarget(name: "SwiftJLICLI", dependencies: ["SwiftJLI"]),
        .testTarget(name: "SwiftJLITests", dependencies: ["SwiftJLI"])
    ],
    swiftLanguageModes: [.v6]
)
