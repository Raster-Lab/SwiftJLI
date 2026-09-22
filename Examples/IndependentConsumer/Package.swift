// swift-tools-version: 6.4
// SPDX-License-Identifier: Apache-2.0
import PackageDescription

let package = Package(
    name: "IndependentConsumer",
    platforms: [.macOS("27.0")],
    dependencies: [.package(path: "../..")],
    targets: [
        .executableTarget(name: "IndependentConsumer", dependencies: [
            .product(name: "SwiftJLI", package: "SwiftJLI")
        ])
    ],
    swiftLanguageModes: [.v6]
)
