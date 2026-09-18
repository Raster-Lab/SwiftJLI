// SPDX-License-Identifier: MIT
import Foundation
import SwiftJLI

/// A client of the public product, deliberately without @testable access.
/// The synthetic image proves the storage/API contract; it is not JPEG output.
@main
struct StandaloneConsumer {
    static func main() async throws {
        let descriptor = try SwiftJLI.ImageDescriptor.greyscale16(
            width: 3, height: 2, meaningfulBits: 12, rowBytes: 8, offset: 2
        )
        let destination = try SwiftJLI.ImageDestination.allocate(descriptor: descriptor)
        let samples: [UInt16] = [0, 4095, 1, 2048, 17, 4094]
        for y in 0..<2 {
            for x in 0..<3 { try destination.setSample(samples[y * 3 + x], x: x, y: y) }
        }
        let image = try destination.seal()
        guard image.descriptor.meaningfulBits == 12 else {
            throw ConsumerFailure.precisionChanged
        }
        for y in 0..<2 {
            for x in 0..<3 {
                guard try image.sample(x: x, y: y) == samples[y * 3 + x] else {
                    throw ConsumerFailure.sampleChanged
                }
            }
        }

        let encoder = try SwiftJLI.Encoder()
        let decoder = try SwiftJLI.Decoder()
        try await expectUnimplemented { _ = try await encoder.encode(image) }
        try await expectUnimplemented { _ = try await decoder.decode(Data()) }
        do {
            _ = try decoder.inspect(Data())
            throw ConsumerFailure.unexpectedCodecSuccess
        } catch let error as SwiftJLI.CodecError {
            guard error.category == .unsupportedFeature else { throw error }
        }
        print("SwiftJLI public storage contract passed; JPEG algorithms remain unimplemented.")
    }

    private static func expectUnimplemented(_ operation: @Sendable () async throws -> Void) async throws {
        do {
            try await operation()
            throw ConsumerFailure.unexpectedCodecSuccess
        } catch let error as SwiftJLI.CodecError {
            guard error.category == .unsupportedFeature else { throw error }
        }
    }
}

private enum ConsumerFailure: Error {
    case precisionChanged
    case sampleChanged
    case unexpectedCodecSuccess
}
