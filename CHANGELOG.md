# Change log

- Final Milestone 1 review: prevent image publication when cancellation occurs inside provider sealing/validation; deterministic regressions and full checks pass.

## Unreleased — Milestone 1 contract implementation, 2026-09-18

- Added an independent Swift 6.2-minimum package in Swift 6 language mode, checked sample/plane descriptors, resource profiles and explicit errors.
- Implemented owning sample storage, opaque exclusive write leases, atomic seal/abort lifecycle, retained immutable images and checked unsigned 16-bit sample helpers.
- Added common encoder/decoder API shapes with truthful empty capabilities and explicit unsupported-operation errors. No JPEG algorithm, real inspector, CLI or transcoder is implemented.
- Added synthetic descriptor, lifetime, adapter, concurrent access, cancellation, resource and independent-consumer coverage. Exact executed commands and remaining gates are in `Documentation/MILESTONE1.md`.
- Kept predecessor algorithms, `JLIDICOM`, `JLIBench` and their third-party fixture/oracle qualification deferred to the later migration milestones.

## Unreleased — documentation foundation, 2026-09-17

- Defined the standalone SwiftJLI successor and intended first stable version 1.0.0.
- Added the common API, memory, platform, CLI, testing and performance specifications, codec-specific agent instructions, source provenance and MIT licence.
- No source migration, implementation, package manifest, executable test, binary or release tag is included.
- No runtime behaviour, support matrix or performance result is claimed as verified.

## Documentation clarification — contract 0.1.1, 2026-09-17

- Aligned the suite policy, README and agent handoff with the staged implementation plan: contract feasibility first, codec migration second, shared-storage integration third.
- Added explicit Milestone 1 test evidence and labelled the later codec delivery sections to prevent accidental expansion of the first task.
- Mirrored all seven common documents and regenerated their SHA-256 manifest across the four repositories. API/memory behaviour, platform floors, intended library versions and release gates are unchanged.
- Verified documentation consistency and links; no codec code or executable tests were added or run.

## Native transcoding instructions — contract 0.2.0, 2026-09-18

- Added a common native format-pair API/CLI pattern and explicit in-memory ownership, fidelity and testing requirements for SwiftJ2K and SwiftJXL.
- Distinguished sample-exact J2K ↔ HTJ2K conversion from original-JPEG-byte restoration through JPEG XL. Neither operation requires an umbrella or sibling codec dependency.
- Recorded predecessor implementation/test findings in the relevant repositories; kept Milestone 1 scoped to feasibility. No native transcode placeholder is required in SwiftJLS/SwiftJLI.
- Updated all seven shared documents and their SHA-256 manifest. This is documentation only; no source migration, codec execution or performance claim.

The foundation document version is 0.2.0. It is separate from the intended library version.
