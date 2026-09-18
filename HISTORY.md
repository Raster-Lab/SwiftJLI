# History and provenance — SwiftJLI

## Documentation foundation — 17 September 2026

The owner chose four fresh repositories under Raster-Lab, with independent codecs, a common API and memory contract, MIT licensing and an optional adapter-based umbrella. The previous proposal for a new shared-foundation package, SwiftCompressionFamily 2.0.0, was superseded. The intended first stable release here is 1.0.0; no library version has been released or tagged by this foundation.

| Item | Recorded source |
| --- | --- |
| Predecessor | [Raster-Lab/JLISwift](https://github.com/Raster-Lab/JLISwift) |
| Default branch observed | main |
| Inspected source snapshot | [9f1c6eb609fe6f26498db82b13df6b305630a374](https://github.com/Raster-Lab/JLISwift/commit/9f1c6eb609fe6f26498db82b13df6b305630a374) |
| Highest stable-shaped tag observed | [v0.5.0](https://github.com/Raster-Lab/JLISwift/tree/v0.5.0) |
| Source-tree licence observed | Apache-2.0 |
| Successor licence | MIT, for owner-authorised in-house material |
| Inspection date | 2026-09-17 |

The tag and the inspected branch snapshot are separate references; this record does not assert they resolve to the same commit. Before migrating a tagged baseline, resolve annotated tags to commits and record the exact chosen SHA. The pinned snapshot above was read for documentation preparation; it was not independently built or regression-tested in this task.

## Migration provenance requirements

The coding agent must record source repository, commit, original path and successor path for each migrated subsystem, and distinguish copied/adapted in-house material from new implementation. Record retained tests, fixture licences and explicit product/feature dispositions. Keep predecessor bug history accessible through links. Do not import old tags, rewrite predecessor history or imply all historical commits have been relicensed.

The owner states the implementation is in-house and has authorised MIT relicensing. Preserve accurate original copyright years and ownership. Audit any third-party dependencies, tools or fixtures separately. The MIT root licence is not authority to remove another party's notices.

The originals are intended to become maintenance projects while new development moves here. No predecessor settings, README, branch, release, licence or archive flag was changed during this documentation preparation. Maintenance announcements and downstream DICOMKit/Voxelia migration are separate work.

## Swift 6.4 development upgrade — 19 September 2026

The owner assigned the successor upgrade before Milestone 2 and requested version increments. Starting from `62e9502082a90bbabedf3d554b58e6dc8356b30a`, the candidate requires Swift tools 6.4 in Swift 6 language mode, advances shared contract 0.2.1 to 0.3.0 and advances the unreleased 1.0.0 target to 1.1.0 (`1.1.0-dev.1` development identifier). Platform floors, public API signatures, licensing and codec milestone scope are preserved. This is not a release/tag. The [upgrade record](Documentation/Engineering/Swift64/README.md) keeps current evidence separate from the earlier historical reports.
