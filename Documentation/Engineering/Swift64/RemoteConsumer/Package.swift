// swift-tools-version: 6.4
import PackageDescription
let package = Package(name: "RemoteMigrationConsumer", platforms: [.macOS("26.0")],
 dependencies: [.package(url: "https://github.com/Raster-Lab/SwiftJLI.git", revision: "574c16a2eb09d62bf1253076d81c10c40bb5d36e")],
 targets: [.executableTarget(name: "MigrationExample", dependencies: [.product(name: "SwiftJLI", package: "SwiftJLI")])],
 swiftLanguageModes: [.v6])
