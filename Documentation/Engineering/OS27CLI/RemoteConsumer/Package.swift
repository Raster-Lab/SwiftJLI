// swift-tools-version: 6.4
import PackageDescription
let package = Package(name: "RemoteMigrationConsumer", platforms: [.macOS("27.0")],
 dependencies: [.package(url: "https://github.com/Raster-Lab/SwiftJLI.git", revision: "82e5adbb9e778e3ef83cf7da743acf79e9196256")],
 targets: [.executableTarget(name: "MigrationExample", dependencies: [.product(name: "SwiftJLI", package: "SwiftJLI")])],
 swiftLanguageModes: [.v6])
