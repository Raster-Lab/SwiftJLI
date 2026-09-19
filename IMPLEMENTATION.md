# SwiftJLI — staged implementation instructions

Read AGENTS.md and every common contract document first. Milestone 1 implements API shapes and owning storage; see [executed evidence](Documentation/MILESTONE1.md). Later milestones require an owner-assigned implementation task. Follow the common contract when predecessor conventions differ. Maintain performance, reliability and security together.

## Source and destination

Predecessor: [Raster-Lab/JLISwift](https://github.com/Raster-Lab/JLISwift) at inspected SHA `9f1c6eb609fe6f26498db82b13df6b305630a374`. Highest stable-shaped tag observed: `v0.5.0` (resolve independently before choosing it as a baseline). Target module/product: `SwiftJLI`. Target CLI: `swiftjli`. Intended first stable library version: `1.1.0`.

Do not migrate code from moving main without recording the selected revision. Reproduce relevant source tests and inspect source-level capabilities. Existing test totals and benchmark claims are historical, not successor acceptance evidence.

[MIGRATION.md](MIGRATION.md) describes the consumer-side upgrade from JLISwift, with current API mappings and deferred features. Update it as each assigned milestone adds qualified capabilities; its staged cutover checklist supplements the implementation gates below.

## Milestones and exit evidence

| Milestone | Work | Exit evidence |
| --- | --- | --- |
| 1 — contract feasibility | Establish Swift 6.4 package, independent local API/owning-memory types, descriptor validation and safe adapter experiment; no codec algorithm migration | Compiling equivalent public calls, lifecycle/race/error tests, standalone consumer build and contract issues resolved explicitly |
| 2 — migration baseline | Inventory predecessor subsystems/products; select and migrate the smallest native scalar lossless path with MIT/provenance reconciliation | Pinned predecessor comparison, independent decode/encode validation, exact sample/precision results, no new runtime codec dependency |
| 3 — shared-storage path | Direct final decode into caller storage and encode from compatible sealed storage | Required-sharing copy/allocation/lifetime proof; first suite pair or corresponding codec extension passes |
| 4 — feature/platform coverage | Extend supported modes/layouts, CLI, optional acceleration and all required OS/architecture paths | Capability matrix, codec-specific regressions, platform results, security and performance evidence |
| 5 — release preparation | Validate clean versioned consumption, docs/examples, migration guide, licence/fixture notices and release gates | Reviewed complete evidence; stable tag only after explicit release task |

Work one owner-assigned milestone at a time. Preserve internal algorithm names where helpful, but provide the agreed common public module surface. Do not publish a stable version or announce complete platform support while required gates are missing.


### Migration focus

- The predecessor has a native encoder and decoder. Do not treat this project as lossy encode-only or require an operating-system decoder. Preserve native decode on Linux and Apple platforms for the modes actually supported.
- `Sources/JLISwift/Encoder/JLIEncoder.swift` returns `[UInt8]`; `Sources/JLISwift/Decoder/JLIDecoder.swift` uses `decode(from:configuration:)`; `Core/JLIImage.swift` owns `[UInt8]`. Adapt these to common names, Data-based encoded results and owner-backed image views. Audit array conversions so they cannot hide full-frame copies.
- Distinguish baseline/extended/progressive lossy JPEG from SOF3 lossless JPEG. The common default lossless mode selects validated SOF3 with point transform zero. A nonzero point transform discards low-order information and cannot satisfy the sample-exact lossless declaration. High lossy quality is never advertised as lossless.
- Inventory supported 8/12-bit lossy modes and 2..16-bit lossless precision, predictors, sampling, colour models, restart markers and metadata. Explicitly reject unsupported requested combinations.
- The predecessor's float encode/decode scaling conventions differ in some paths. Document and reconcile them with the common descriptor; no silent [0,1] normalisation or raw-sample reinterpretation. Keep float support capability-specific until exact semantics are tested. Signedness metadata is not guaranteed by a generic JPEG output file.
- `Platform/AccelerateBackend.swift` uses vImage/DSP. Keep Apple adapters optional and implement/retain scalar correctness on Linux. Apple OS codecs may be test comparators, not required runtime substitutes.
- Inventory the optional JLIDICOM product separately. DICOM object parsing and metadata stay outside the new principal codec module. Preserve useful optional integration deliberately or record its deferral; do not silently pull DICOMKit into the core.

### Codec-specific tests

Test marker/table/scan bounds, Huffman and arithmetic bounds where applicable, restart handling, baseline/extended/progressive decode, 12-bit cases and SOF3 predictor/point-transform combinations. Independent validation must use an oracle that actually supports the selected JPEG mode and precision; an OS decoder supporting only baseline JPEG is insufficient for SOF3/16-bit gates.

Test full 16-bit unsigned extrema, component order, byte order, signed mappings only with explicit metadata, ICC/Exif size limits and float policy rejection. Compare lossless samples exactly; pin justified tolerances for lossy colour conversion/DCT paths. Preserve existing overflow, subsampling, configuration and Watch build reproducers.

### Initial codec delivery — Milestones 2–4

The following codec work follows Milestone 1 contract feasibility. It is not part of the first coding task. Migrate the scalar path in Milestone 2, prove shared storage in Milestone 3, and extend features/CLI/platform coverage in Milestone 4.

Build on the validated common surface to implement a native unsigned 16-bit lossless SOF3 shared-buffer path. Add the per-codec CLI and interop tests without assuming the predecessor benchmark executable is a general CLI. Join the suite transcode harness for lossless JPEG modes; retain lossy features as explicit options.


## Required handover

Update CHANGELOG.md and migration provenance. Provide the exact commands, commits, fixture hashes and outcomes; report tests not run and why, unsupported cases, allocation/copy evidence and performance impact. Map each advertised feature to a test and capability entry. Keep DICOMKit/Voxelia source changes outside this repository task unless the owner separately assigns them.

## Owner-authorised OS 27 and CLI foundation

Before codec migration, the owner raised Apple floors to 27.0 and requested executable help, verbosity and UNIX manuals. This bounded CLI foundation implements help/version/capabilities only; codec commands remain explicitly unavailable. See [CLI.md](CLI.md) and [new evidence](Documentation/Engineering/OS27CLI/README.md). The later codec/CLI milestones still govern real payload operations.
