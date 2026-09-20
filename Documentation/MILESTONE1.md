# Milestone 1: contract feasibility

**Final validation after review:** 29 Swift Testing tests passed in each of debug, release, AddressSanitizer and ThreadSanitizer; every command and the independent consumer exited 0. The final source hashes, complete command lines, logs and XML are in [Validation/final](Validation/final). Earlier tables below record the preceding implementation snapshot; this final evidence supersedes their test counts and source fingerprints.


This change implements the local API and owning-memory experiment. It does not implement JPEG encoding, decoding, inspection or transcoding. Real codec capabilities are empty and operations fail explicitly until their separately assigned migration milestone.

## Revisions and provenance

- Successor foundation: `4598f73289f18ccc192be8217fdeccfed9357eef`.
- Work branch: `codex/milestone-1-contract`.
- Contract on entry: `0.2.0`; implemented coordinated refinement: `0.2.1`, with concrete lease signatures and retained resource budgets in the mirrored common contract and its SHA-256 manifest.
- Pinned predecessor: [Raster-Lab/JLISwift at 9f1c6eb609fe6f26498db82b13df6b305630a374](https://github.com/Raster-Lab/JLISwift/tree/9f1c6eb609fe6f26498db82b13df6b305630a374).
- All implementation and synthetic tests in this milestone are new MIT material. No predecessor algorithm or third-party fixture was copied. Synthetic inputs are defined directly in the tests; their expected values are constants, not codec-generated expectations.

The predecessor was inspected at the exact pinned commit. Its root has no `AGENTS.md` or `CLAUDE.md`. The source package has `JLISwift`, `JLIDICOM` and `JLIBench` products with no package dependency. `JLIDICOM` and `JLIBench` are deferred and are not pulled into the new principal library.

| Pinned predecessor path | Finding / disposition |
| --- | --- |
| `Sources/JLISwift/Core/JLIImage.swift` | Interleaved array ownership, precision derived from pixel format and unchecked dimension multiplication require replacement by checked descriptors and owning storage. Inspected; not migrated. |
| `Sources/JLISwift/Encoder/JLIEncoder.swift` | Native SOF3 and DCT branches; array results and full-frame extraction require an explicit future copy/workspace audit. Direct Accelerate import requires platform separation. Inspected; not migrated. |
| `Sources/JLISwift/Decoder/JLIDecoder.swift` | Native SOF3 and progressive decode branches exist; the top-level progressive-support prose is stale. Float output uses raw reconstructed values, whereas encoder float input is normalised. Inspected; not migrated. |
| `Tests/JLISwiftTests/LosslessTests.swift` | Future baseline candidates include every predictor, 16-bit extrema, sub-8-bit over-read regression and point-transform cases. Test presence is not execution evidence. |
| `Tests/JLISwiftTests/LosslessRestartTests.swift` | Future baseline candidates include restart fixtures, parallel/serial equivalence and corrupt-segment rejection. Oracle prerequisites must be audited before migration. |
| `Tests/JLISwiftTests/MedicalSafetyTests.swift` | Predecessor lossy defaults and signed RAM interpretation must not leak into successor lossless defaults or imply standalone signed codestream portability. |
| `Tests/JLISwiftTests/EdgeCaseTests.swift` | ICC boundary, restart interval and 12-bit scaled decode cases retained as future inventory. |

Predecessor compilation, codec regression, independent JPEG oracle comparison and throughput baselines are deferred to Milestone 2. No codec subsystem is changed or advertised by this work.

## Validation environment

Local host: macOS `27.0` build `26A428`, `arm64`. Xcode `27.0` build `27A266a`; Apple Swift `6.4` (`swiftlang-6.4.0.34.1`, clang `2100.3.34.1`). The package requires Swift tools 6.2, Swift 6 language mode and exactly OS 26.0 deployment minima. Every build sets `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer` for that command; the system Xcode selection is unchanged.

Swift 6 language mode enables complete strict-concurrency checking without dependency-hostile manifest unsafe flags. An actual Swift 6.2 compiler is not installed on this host, so minimum-toolchain runtime verification is unexecuted. Linux, native Intel, Apple simulator and physical-device qualification remain separate gates.

## Results

The final debug, release, AddressSanitizer and ThreadSanitizer runs each report **28 tests, zero failures, zero skips**, with exit code 0. The parameterised precision test executes both 12-bit and 16-bit cases. These counts refer to Swift Testing's result, not the XCTest wrapper's separate zero-test banner. [Machine-readable reports and logs](Validation/) retain the actual outcomes.

| Command / check | Result |
| --- | --- |
| Xcode `xcrun swift test`, debug | Exit 0; 28 tests passed. |
| Xcode `xcrun swift test --sanitize address` | Exit 0; 28 tests passed; no AddressSanitizer findings. |
| Xcode `xcrun swift test --sanitize thread` | Exit 0; 28 tests passed; no ThreadSanitizer findings. |
| Independent consumer `xcrun swift run` | Exit 0; synthetic samples, allocation identity and all common operation call shapes validated. |
| Initial release `xcrun swift test -c release` | Exit 1 at `GenerateDSYMFile`: `dsymutil` reported `Operation not permitted` in the agent sandbox. Source and tests compiled before the tool failure; this attempt is not a release-test pass. |
| Final release `xcrun swift test -c release` from coordinating agent | Exit 0; all 28 tests passed with Xcode's standard SwiftBuild engine after rerunning from the parent execution context. No source workaround or relaxed compiler setting was needed. |
| `xcodebuild -list` | Exit 66; this installation's frontend did not recognise the bare Swift package as a project/workspace/package, with unavailable simulator-service diagnostics. SwiftPM used Xcode's compiler and `swiftbuild` engine successfully. |
| `git diff --check` | Exit 0. |

The following are exact commands from the repository root; output was redirected to matching `.build/*-test.log` files. The test tool adds `-swift-testing` to the requested XML names.

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer CLANG_MODULE_CACHE_PATH=.build/module-cache xcrun swift test --disable-sandbox --scratch-path .build --cache-path .build/cache --config-path .build/config --security-path .build/security --xunit-output .build/debug-tests.xml
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer CLANG_MODULE_CACHE_PATH=.build/module-cache xcrun swift test -c release --disable-sandbox --scratch-path .build --cache-path .build/cache --config-path .build/config --security-path .build/security --xunit-output .build/release-tests.xml
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer CLANG_MODULE_CACHE_PATH=.build/asan-module-cache xcrun swift test --sanitize address --disable-sandbox --scratch-path .build/asan --cache-path .build/cache --config-path .build/config --security-path .build/security --xunit-output .build/asan-tests.xml
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer CLANG_MODULE_CACHE_PATH=.build/tsan-module-cache xcrun swift test --sanitize thread --disable-sandbox --scratch-path .build/tsan --cache-path .build/cache --config-path .build/config --security-path .build/security --xunit-output .build/tsan-tests.xml
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -list
git diff --check
```

The successful release rerun used the following command from this repository, with shared scratch configuration in the task workspace. Its output is retained in `Validation/release-test-final.log` and `Validation/release-tests-swift-testing.xml`; the failed initial attempt is retained separately as `Validation/release-test.log`.

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer CLANG_MODULE_CACHE_PATH=/Users/suresh/Documents/Codex/2026-09-18/create-coding-agents-to-start-work/work/clang-module-cache xcrun swift test -c release --disable-sandbox --jobs 2 --cache-path ../../work/cache-jli --config-path ../../work/config-jli --security-path ../../work/security-jli --xunit-output ../../work/logs/SwiftJLI-release.xml
```

Run the consumer command from `Examples/IndependentConsumer`:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer CLANG_MODULE_CACHE_PATH=.build/module-cache xcrun swift run --disable-sandbox --scratch-path .build --cache-path .build/cache --config-path .build/config --security-path .build/security
```

## Ownership and sample evidence

`StorageWriteLease` is an opaque `Sendable` UUID value. The same provider enforces `reserveWrite`, `withUnsafeMutableBytes(lease:_:)`, `finishAndSeal(lease:)` and `abortAndInvalidate(lease:)` across wrappers. Copying a token does not create a second writer. The six common implementation files are copied locally into each independent package; there is no shared runtime module or sibling dependency.

The owned provider stores its array behind `Synchronization.Mutex`. It uses a nonblocking lock attempt to reject competing and reentrant mutable borrows, then transfers the array to an immutable sealed owner. No raw pointer is stored and no unchecked concurrency annotation is used. Raw borrowing is synchronous; caller obligations explicitly prohibit pointer escape and asynchronous use. Storage is zero-initialised, including padding. The checked synthetic sample helper rejects values above the declared meaningful range and checks task cancellation at every row and before publication.

- [Ownership tests](../Tests/SwiftJLITests/OwnershipTests.swift) exercise two forwarding wrappers, a forged lease, 16 simultaneous reservation attempts, overlapping borrows using the same token, reentrant state changes, nested/concurrent sealed reads, failure/abandonment and an adapter's exactly-once destruction after the final image is released.
- [Descriptor tests](../Tests/SwiftJLITests/DescriptorTests.swift) independently expect full unsigned extrema, 12-bit extrema, odd 3×3 geometry, row padding/prefix zeros, exact and short capacities, overlapping planes, byte-order resolution, invalid strides/precision and `Int.max` arithmetic rejection.
- [API tests](../Tests/SwiftJLITests/APITests.swift) exercise defined unsupported results, required-backend rejection, allocation and row cancellation, unchanged meaningful precision, exact big-endian bytes, caller metadata budgets and explicit limits above the default. This regression prevents publication from silently reverting to smaller default limits.
- [Limit tests](../Tests/SwiftJLITests/LimitTests.swift) cover admission boundaries, padding accounting, dimension/pixel limits, nonfinite deadlines and the Watch resource profile values.

Tests observe exact samples and allocation identity through retained adapters. Source review finds one owned sample-array construction and reference transfer on sealing; this milestone does not claim allocator-instrumented codec hand-off performance. It has no codec workspace, compressed output or real transcoder to measure. Unknown operation metrics remain `nil`; no zero-copy, latency, memory-peak or throughput number is fabricated.

## Remaining gates

Codec algorithms and oracles, real format parsers and one-hour fuzz campaigns, CLI semantics, process-wide memory admission across simultaneous codec operations, algorithm deadlines/progress, accelerated backends, allocator instrumentation and controlled codec benchmarks belong to later milestones. Raw caller fill closures control their own work bounds. Pool reuse is not implemented. Signed/float descriptors describe memory only and do not advertise JPEG support. Subsampled planes are explicitly rejected.

Swift 6.2 compiler execution, Linux ARM64/x86_64, native macOS Intel and Apple simulator/device execution remain unexecuted. The included consumer validates standalone local package consumption without sibling discovery; a fresh remote versioned consumer requires publication and is not claimed here. No stable tag or release is created.

## Additional Apple SDK compilation

Nine source-module builds passed using Xcode 27 Swift 6.4, explicit Swift 6 language mode and complete concurrency checking: macOS x86_64; iOS/tvOS/visionOS arm64 device and simulator; watchOS arm64_32 device and arm64 simulator. All target deployment versions were 26.0 using installed SDK 27.0. This is module compilation only, not linking, simulator execution or native-device qualification. Exact commands, exit codes and source hashes are in [apple-sdk-compilation.json](Validation/apple-sdk-compilation.json). The complete four-module matrix passed 36 of 36 compiler checks with no diagnostics.

## Final publication-cancellation correction

Independent review found that cancellation inside an external provider's sealing or validation callback could occur after the last cancellation check. The write now constructs its owning image, checks task cancellation immediately before returning, and publishes only on success. A deterministic parameterised regression cancels during `finishAndSeal` and during the returned read-owner validation borrow. Both cases throw `CancellationError` and permanently prevent destination reuse. If the provider has already sealed, its private read owner is discarded without publishing an Image; cleanup cannot reopen that sealed allocation. No workers or pointers outlive the operation.

All final test runs explicitly select Swift Testing with `--disable-xctest`: these packages contain no XCTest cases. The first final-validation attempt executed every Swift Testing case successfully but exited 1 because Xcode 27's empty XCTest compatibility bundle could not be loaded from the separate scratch directory. That failed runner log is retained; the corrected invocation runs all actual tests and returns 0. This is runner selection, not a test skip or suppression of a failing test. All nine Apple SDK module checks were repeated after the source fix and passed.
