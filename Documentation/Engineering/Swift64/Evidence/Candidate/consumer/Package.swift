// swift-tools-version: 6.4
import PackageDescription
let package = Package(name: "FreshConsumer", platforms: [.macOS(.v26)],
 dependencies: [.package(path: "/Users/suresh/Documents/Codex/2026-09-18/create-coding-agents-to-start-work/outputs/SwiftJLI")],
 targets: [.executableTarget(name: "Consumer", dependencies: [.product(name: "SwiftJLI", package: "SwiftJLI")])],
 swiftLanguageModes: [.v6])
