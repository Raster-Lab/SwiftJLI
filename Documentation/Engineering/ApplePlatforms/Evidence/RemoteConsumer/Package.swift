// swift-tools-version: 6.4
import PackageDescription
let package = Package(
    name: "RemoteConsumerSwiftJLI",
    platforms: [.macOS("27.0")],
    dependencies: [.package(url: "https://github.com/Raster-Lab/SwiftJLI.git", revision: "a520962dcb99884c337a1bf528bfcacbec0c1dba")],
    targets: [.executableTarget(name: "Consumer", dependencies: [.product(name: "SwiftJLI", package: "SwiftJLI")])],
    swiftLanguageModes: [.v6]
)
