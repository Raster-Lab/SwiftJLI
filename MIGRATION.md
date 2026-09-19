# Migrating applications from JLISwift to SwiftJLI

The successor now requires Swift 6.4 and retains its OS 27 deployment floors. See the [Swift 6.4 upgrade record](Documentation/Engineering/Swift64/README.md) for development versioning and validation; current codec availability is unchanged.

This guide is for application maintainers and coding agents. It describes **Milestone 1, contract 0.4.0**: SwiftJLI provides public API shapes and owning sample storage, but **does not yet inspect, encode or decode JPEG**. Keep JLISwift serving real codec operations until the particular successor modes your application needs are implemented and qualified. Renaming the dependency and imports alone is insufficient.

The predecessor API was inspected at [JLISwift `9f1c6eb609fe6f26498db82b13df6b305630a374`](https://github.com/Raster-Lab/JLISwift/tree/9f1c6eb609fe6f26498db82b13df6b305630a374), not an assumed version range. Its historical `v0.5.0` tag is a separate reference. See [provenance](HISTORY.md), [current implementation evidence](Documentation/MILESTONE1.md) and the [remaining milestones](IMPLEMENTATION.md). Source inspection does not establish that predecessor codec tests passed.

## 1. Inventory and pin the application baseline

Record the application's resolved JLISwift commit, tools/SDK versions, deployment targets and existing test failures. Inventory imports, products, `JLIImage` construction, encode/decode/inspection calls, configuration values, metadata handling and error switches. Preserve representative existing JPEG files and expected samples, including signed and high-precision cases, before editing.

| Dependency or build item | JLISwift baseline | SwiftJLI target |
| --- | --- | --- |
| Repository | `https://github.com/Raster-Lab/JLISwift.git` | `https://github.com/Raster-Lab/SwiftJLI.git` |
| Package / core product / import | `JLISwift` | `SwiftJLI` |
| Optional products | `JLIDICOM`, executable `JLIBench` | No equivalents currently shipped; retain or explicitly defer |
| Swift toolchain | Pinned manifest requires 6.2 | 6.4 minimum; Swift 6 language mode |
| Apple deployment floors | macOS 14, iOS/tvOS 17, watchOS 10, visionOS 1 | All 27.0 |

The intended SwiftJLI `1.1.0` is **not a published release requirement**. For a migration trial, use a reviewed checkout with `.package(path: "../SwiftJLI")`; add `.product(name: "SwiftJLI", package: "SwiftJLI")` to the consumer target's dependencies. Alternatively select an actually available, reviewed revision of the new repository and record its full SHA in the package requirement. Do not invent a `from: "1.1.0"` requirement or rely on moving `main`. Preserve `Package.resolved` in the application where applicable.

In Xcode, add the successor package/product to an experimental target and use `import SwiftJLI`. Keep older deployment targets on their existing dependency while evaluating the OS 27 requirement. Linux and other platform qualification must be checked against [recorded evidence](Documentation/MILESTONE1.md), rather than inferred from the [intended platform matrix](Documentation/PLATFORMS.md).

## 2. Map operations explicitly

The right-hand call shapes below exist in source. Codec rows remain **unsupported in Milestone 1**; capabilities have `canInspect`, `canEncode` and `canDecode` all `false` and empty format/mode lists. Validation may fail before the deliberate `CodecError(.unsupportedFeature, ...)` result.

| Earlier API or behaviour | Successor API and migration action |
| --- | --- |
| `JLIImage(width:height:pixelFormat:colorModel:data:isSigned:iccProfile:exif:)` owns `[UInt8]` | `ImageDescriptor` describes sample meaning/layout; `Image` retains sealed `ReadOnlyImageStorage`. Build through `ImageDestination` or a correctly owning provider. |
| `JLIEncoder().encode(image, configuration: config) throws -> [UInt8]` | Configure `try SwiftJLI.Encoder(configuration:)`, then `try await encoder.encode(image, options:) -> EncodedImage`. Compressed bytes are `result.data: Data`; inspect `result.report`. **Encoding deferred.** |
| `JLIDecoder().decode(from: bytes, configuration: config)` | Configure `try SwiftJLI.Decoder(configuration:)`, then `try await decoder.decode(Data, options:) -> DecodedImage`; use `result.image`. **Decoding deferred.** |
| `JLIDecoder().inspect(data: bytes) -> JLIJPEGInfo` | `try decoder.inspect(Data, options:) -> ImageInfo`; geometry/precision move into `descriptor`. Old progressive/XYB/subsampling fields have no qualified replacement. **Inspection deferred.** |
| Decoder-owned result array | `decode(_:into:options:)` also exists for caller storage, but performs no decode today. Direct shared-storage codec proof is a later milestone. |
| Mutable `JLIEncoderConfiguration` passed on each call | Immutable `EncoderConfiguration` belongs to the encoder; `EncodeOptions` carries per-call limits/execution/copy/metadata policy. `CodecOptions` is currently empty. |
| `JLIError` cases | Handle `CodecError.category` and Swift `CancellationError` explicitly; do not mechanically rename old case switches. |

Do not add a synchronous wrapper that blocks an actor waiting for an async operation. Move async handling through the application service boundary. Qualify shared names such as `SwiftJLI.Image` and `SwiftJLI.Encoder` when importing other suite codecs; their identically named types are distinct.

## 3. Preserve JPEG mode and sample semantics

- **Default changes:** the pinned predecessor's `.default` is lossy quality 90 with 4:2:0 sampling. SwiftJLI's configuration defaults to `.lossless`; it does not currently encode. Do not claim equivalent output or size after substituting defaults. The planned lossless mode is native SOF3 with point transform zero. High-quality baseline/extended/progressive JPEG is still lossy.
- **Options are deferred:** quality/distance, sampling, XYB, progressive scan scripts, restart interval, predictor, point transform, adaptive/perceptual quantisation and decoder output-format/colour/scale controls have no implemented successor mapping. Current `.lossy` and positive `.nearLossless(...)` configurations throw `unsupportedFeature`. A nonzero predecessor `losslessPointTransform` discards low bits; it cannot satisfy sample-exact lossless acceptance.
- **Precision is explicit:** old `.uint16` storage does not by itself mean a 16-bit JPEG. The pinned lossless configuration derives 12 bits from `.uint16` when `losslessPrecision == 0`; full 16-bit use requires an explicit old precision of 16. Set the new `storageBits` and `meaningfulBits` from the application's declared source semantics, not observed extrema. Low-align meaningful integer bits; preserve 0/4095 for 12-bit and 0/65535 for 16-bit data. Descriptor acceptance is not codec support for that precision.
- **Layouts and colour:** the old image is tightly packed, row-major and interleaved. Map every plane, component, byte order, offset and stride explicitly; padding is not pixels. Current descriptors reject subsampled planes. Do not convert YCbCr/CMYK/XYB/RGBA to RGB or discard alpha simply to fit the new API. Additional codec layouts remain unqualified.
- **Signed samples:** map `isSigned` to a declared signed sample type only with an explicit interpretation contract. A RAM flag cannot guarantee portable signedness in standalone JPEG. Preserve the external metadata and test signed extrema, or reject output that cannot represent the required meaning. Never offset or reinterpret signed data silently.
- **Float samples:** the old encoder treats float input as normalised `[0,1]` and quantises to 8-bit; supported old float decode paths return raw reconstructed sample values. Preserve this distinction in the application inventory. SwiftJLI's float descriptor support does not imply a float codec path. Do not normalise, reinterpret or accept non-finite values without a separately tested policy.
- **Metadata:** map ICC bytes deliberately to `ImageDescriptor.iccProfile`; image-level metadata uses `ImageMetadata`. There is no implemented JPEG Exif field/marker mapping or metadata round trip yet. Keep Exif and required interpretation data in the application until its codec mapping is qualified. Default `.preserve` does not make stub operations preserve a file. `.discardAncillary` may never discard required sample/colour meaning.

The old definitions are in [JLIImage.swift](https://github.com/Raster-Lab/JLISwift/blob/9f1c6eb609fe6f26498db82b13df6b305630a374/Sources/JLISwift/Core/JLIImage.swift) and [JLIConfiguration.swift](https://github.com/Raster-Lab/JLISwift/blob/9f1c6eb609fe6f26498db82b13df6b305630a374/Sources/JLISwift/Core/JLIConfiguration.swift); verify actual paths and fixtures rather than interpreting their comments as successor guarantees.

## 4. Compile a storage/API trial today

This standalone executable source uses only the current public SwiftJLI product. It verifies 12 meaningful bits in padded 16-bit storage and the expected unsupported encoder result; it performs **no JPEG compression**. Put it in the consumer executable's `main.swift` after adding the local package above.

```swift
import Foundation
import SwiftJLI

enum MigrationTrialError: Error {
    case sampleMismatch, unexpectedCapability, unexpectedEncodeSuccess
}

let limits = try SwiftJLI.ResourceLimits(
    maximumDecodedBytes: 1024, maximumMemoryBytes: 4096)
let descriptor = try SwiftJLI.ImageDescriptor.greyscale16(
    width: 3, height: 2, meaningfulBits: 12, rowBytes: 8, limits: limits)
let destination = try SwiftJLI.ImageDestination.allocate(
    descriptor: descriptor, limits: limits)
let samples: [UInt16] = [0, 4095, 1, 2048, 17, 3000]
let image = try destination.writeUInt16 { x, y in samples[y * 3 + x] }
guard try image.sampleUInt16(x: 1, y: 0) == 4095 else {
    throw MigrationTrialError.sampleMismatch
}
let encoder = try SwiftJLI.Encoder()
guard !encoder.capabilities.canEncode else {
    throw MigrationTrialError.unexpectedCapability
}
do {
    _ = try await encoder.encode(image, options: .init(resourceLimits: limits))
    throw MigrationTrialError.unexpectedEncodeSuccess
} catch let error as SwiftJLI.CodecError {
    guard error.category == .unsupportedFeature else { throw error }
}
print("Storage/API trial passed; JPEG encoding remains deferred.")
```

Run the consumer with Xcode's headless toolchain, for example `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun swift run`. The [independent consumer](Examples/IndependentConsumer) covers further public call shapes. When codec work lands, replace the expected rejection with fixture-based assertions for its advertised capabilities.

Do not let pointers from old array/Data borrows escape or survive `await`. An array-to-owned-storage adapter may copy a whole image: record that cost rather than claim zero-copy. New supplied-storage operations default to `.requireSharedStorage`; `.allowCopy` explicitly permits value-preserving layout conversion with reporting. Custom providers must retain the actual allocation, enforce one writer, seal before publication and preserve allocation identity across adapters; see the [memory contract](Documentation/MEMORY_CONTRACT.md).

Set `ResourceLimits` for the application's input, destination, metadata, workspace and concurrent workload. Milestone 1 exercises admission checks, not real JPEG work/deadline enforcement. Preserve error categories, surface resource/backend/layout failures and propagate `CancellationError` without converting it to success or retrying with lossy settings. Once a destination write begins, failure/cancellation invalidates it; a preflight rejection by today's codec stubs leaves the reservation unwritten. Never publish a partial image.

## 5. Stage the change and retain rollback

1. Keep JLISwift pinned and add SwiftJLI in a separate application adapter/experimental target. Keep any necessary old-target build path. Introduce an application-owned codec interface and feature flag so production remains on the qualified predecessor.
2. Run the synthetic trial, then audit copied sample buffers, precision, metadata and errors. Capture the predecessor configuration and expected behaviour for each use case; do not silently route unsupported successor requests to another fidelity mode.
3. After the needed successor modes exist, compare both implementations against the same fixtures and a suitable independent decoder/encoder. Qualify SOF3 and each required lossy mode separately; an oracle supporting baseline JPEG alone cannot validate 16-bit SOF3. Compare logical samples for lossless operation and agreed metrics/tolerances for lossy operation, not arbitrary compressed-byte equality.
4. Enable only validated configurations gradually. Keep the old dependency lock, fixtures and rollback flag until acceptance is complete; a rollback must restore the old adapter and configuration together. Check persisted outputs with all readers before removing the old path. Existing JPEG files do not need rewriting merely because the Swift module changed.

`JLIDICOM` and `JLIBench` are explicit migration deferrals. Keep DICOM parsing, transfer syntax, patient metadata, rescaling and windowing in the application/optional integration. `JLIBench` is a benchmark executable, not equivalent to the new `swiftjli` diagnostic CLI, which provides help/version/capabilities only ([CLI guide](CLI.md)). Do not replace these dependencies or scripts with guessed names, and do not add a sibling codec or umbrella dependency to make SwiftJLI work.

## Acceptance checklist for humans and agents

- [ ] Record exact predecessor/successor SHAs, contract version, tools/SDKs, deployment requirements and a feature/product disposition table.
- [ ] Build the application and a fresh standalone consumer; run relevant existing tests and record failures/skips. The current trial proves storage/API use only.
- [ ] Before production cutover, prove each required codec capability and independent interoperability, including 12/16-bit precision, signedness, colour/alpha, metadata and agreed fidelity.
- [ ] Exercise padded rows, invalid/truncated input, resource exhaustion, cancellation, lifetime/concurrency and copy-policy failures on the supported deployment environments.
- [ ] Record allocations/copies and measured latency/memory for implemented codec paths; do not treat unknown report measurements as zero.
- [ ] Demonstrate rollback and persisted-file compatibility, and explicitly retain/defer every `JLIDICOM`, benchmark and CLI dependency.

Coding agents: read [AGENTS.md](AGENTS.md) and [IMPLEMENTATION.md](IMPLEMENTATION.md), then use this checklist in the application PR. Report implemented, tested, unsupported and unexecuted items separately. This guide authorises no further codec milestone and makes no stable-release or full-platform claim.
