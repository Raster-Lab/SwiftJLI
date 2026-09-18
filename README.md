# SwiftJLI

JPEG, including native lossless JPEG for the **Swift Image Compression Suite**.

**Status: Milestone 1 API and owning-memory implementation.** A standalone Swift package now validates descriptors, retains sealed storage and enforces exclusive write leases. Synthetic storage and public call shapes are tested with the local Xcode toolchain. JPEG algorithms, real format inspection and the CLI are deferred; encoding and decoding report `unsupportedFeature`, and codec capabilities are empty. The intended first stable library version is **1.0.0**; it is not a published release.

SwiftJLI is the standalone successor to [JLISwift](https://github.com/Raster-Lab/JLISwift). The successor is intended to provide a harmonised API, explicit memory ownership, high-precision sample preservation and efficient shared-storage integration. It has no mandatory dependency on another suite library or CompressionFamily. MIT licensing applies to these documents and subsequent authorised in-house implementation; third-party material retains its own terms.

## Intended platform baseline

Swift 6.2 minimum, Swift 6 language mode and complete concurrency checking. Apple OS deployment minima: macOS, iOS/iPadOS, tvOS, visionOS and watchOS 26.0. Apple Silicon is the primary optimisation target. macOS x86_64 and Linux ARM64/x86_64 are included with cleanly separated platform/architecture support. Ubuntu 24.04 is the initial Linux engineering baseline. These are requirements, not completed qualification claims.

## Start reading

The current implementation is **Milestone 1: API and memory-contract feasibility**, using synthetic buffers. See [exact implementation and validation evidence](Documentation/MILESTONE1.md). Codec migration and the first real shared-storage transcode require the separately assigned Milestones 2 and 3.

- [Coding-agent entry point](AGENTS.md) and [codec-specific implementation plan](IMPLEMENTATION.md).
- [Application migration guide: JLISwift → SwiftJLI](MIGRATION.md), including current limitations, API mappings and a staged cutover checklist for humans and coding agents.
- [Suite policy](Documentation/SUITE_POLICY.md) and [common API](Documentation/COMMON_API.md).
- [Memory ownership and no-copy hand-off](Documentation/MEMORY_CONTRACT.md).
- [Unit, regression and security testing](Documentation/TESTING.md).
- [Performance gates](Documentation/PERFORMANCE.md), [platforms](Documentation/PLATFORMS.md) and [CLI](Documentation/CLI_CONTRACT.md).
- [History and source provenance](HISTORY.md), [change log](CHANGELOG.md), [security](SECURITY.md), [contributing](CONTRIBUTING.md) and [MIT licence](LICENSE).

## Relationship to the suite

The four independent libraries are SwiftJ2K, SwiftJLS, SwiftJXL and SwiftJLI, all intended to live under Raster-Lab. A future optional umbrella adapts them for codec selection and in-process transcoding. The codecs do not depend on that umbrella. SwiftCompressionFamily is not part of this successor plan. The common contract is mirrored documentation plus behavioural tests, not a shared runtime package.

The main module is `SwiftJLI`; the planned CLI is `swiftjli`. Features from the predecessor remain migration candidates whose exact coverage must be verified; see IMPLEMENTATION.md. Nothing here changes the predecessor repository's current maintenance configuration.

## Synthetic storage example

This API stores ordinary unsigned sample words. It does not create a compressed image or claim JPEG interoperability.

```swift
import SwiftJLI

let descriptor = try SwiftJLI.ImageDescriptor.greyscale16(
    width: 3, height: 2, meaningfulBits: 16, rowBytes: 8)
let destination = try SwiftJLI.ImageDestination.allocate(descriptor: descriptor)
let image = try destination.writeUInt16 { x, y in
    [UInt16(0), 65535, 4095, 17, 1, 32768][y * 3 + x]
}
let value = try image.sampleUInt16(x: 1, y: 0) // 65535
```

The [independent consumer](Examples/IndependentConsumer) compiles and runs this ownership pattern and the common encoder/decoder call shapes using only this package. Raw `withUnsafeBytes` and mutable-fill closures are advanced boundaries: pointers must not escape or be shared with asynchronous work. Prefer the checked sample helpers for ordinary access.

To run headless with the installed Xcode toolchain:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun swift test
```

See the evidence for sandbox-compatible commands, sanitizer results and unexecuted platform gates. No codec throughput or cross-platform runtime support is claimed by this milestone.
