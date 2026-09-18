// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftJLI",
    platforms: [
        .macOS("26.0"),
        .iOS("26.0"),
        .tvOS("26.0"),
        .visionOS("26.0"),
        .watchOS("26.0")
    ],
    products: [
        .library(name: "SwiftJLI", targets: ["SwiftJLI"])
    ],
    targets: [
        .target(name: "SwiftJLI"),
        .testTarget(name: "SwiftJLITests", dependencies: ["SwiftJLI"])
    ],
    // Swift 6 language mode includes complete concurrency checking. No unsafe
    // manifest flags or sibling package dependencies are required by consumers.
    swiftLanguageModes: [.v6]
)
