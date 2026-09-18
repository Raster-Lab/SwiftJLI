// swift-tools-version: 6.4
import PackageDescription
let package = Package(
    name: "MigrationDocConsumer",
    platforms: [.macOS("26.0")],
    dependencies: [.package(path: "/Users/suresh/Documents/Codex/2026-09-18/create-coding-agents-to-start-work/outputs/SwiftJLI")],
    targets: [.executableTarget(name: "MigrationExample", dependencies: [
        .product(name: "SwiftJLI", package: "SwiftJLI")
    ])],
    swiftLanguageModes: [.v6]
)
