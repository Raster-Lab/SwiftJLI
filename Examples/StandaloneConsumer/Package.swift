// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftJLIStandaloneConsumer",
    platforms: [
        .macOS("26.0"), .iOS("26.0"), .tvOS("26.0"),
        .visionOS("26.0"), .watchOS("26.0")
    ],
    dependencies: [
        // This fixture consumes only this repository through its public product.
        // No sibling checkout or shared-foundation package is discovered.
        .package(path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "StandaloneConsumer",
            dependencies: [.product(name: "SwiftJLI", package: "SwiftJLI")]
        )
    ],
    swiftLanguageModes: [.v6]
)
