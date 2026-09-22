// SPDX-License-Identifier: Apache-2.0
import Foundation
import SwiftJLI

@main struct IndependentConsumer {
    static func main() async throws {
        let descriptor = try SwiftJLI.ImageDescriptor.greyscale16(
            width: 3, height: 2, meaningfulBits: 16, rowBytes: 8)
        let destination = try SwiftJLI.ImageDestination.allocate(descriptor: descriptor)
        let image = try destination.writeUInt16 { x, y in
            [UInt16(0), 65535, 4095, 17, 1, 32768][y * 3 + x]
        }
        guard try image.sampleUInt16(x: 1, y: 0) == 65535,
              image.storage.allocationID == destination.storage.allocationID else {
            throw SwiftJLI.CodecError(.internalFailure, "Synthetic shared-storage check failed.")
        }
        let encoder = try SwiftJLI.Encoder(configuration: .default)
        let decoder = try SwiftJLI.Decoder(configuration: .init())
        guard !encoder.capabilities.canEncode, !decoder.capabilities.canDecode else {
            throw SwiftJLI.CodecError(.internalFailure, "Unexpected codec capability in contract milestone.")
        }
        do {
            _ = try decoder.inspect(Data(), options: .init())
            throw SwiftJLI.CodecError(.internalFailure, "Unexpected successful inspection.")
        }
        catch let error as SwiftJLI.CodecError where error.category == .unsupportedFeature { }
        do {
            _ = try await encoder.encode(image, options: .init())
            throw SwiftJLI.CodecError(.internalFailure, "Unexpected successful encode.")
        }
        catch let error as SwiftJLI.CodecError where error.category == .unsupportedFeature { }
        do {
            _ = try await decoder.decode(Data(), options: .init())
            throw SwiftJLI.CodecError(.internalFailure, "Unexpected successful decode.")
        }
        catch let error as SwiftJLI.CodecError where error.category == .unsupportedFeature { }
        let next = try SwiftJLI.ImageDestination.allocate(descriptor: descriptor)
        do {
            _ = try await decoder.decode(Data(), into: next, options: .init())
            throw SwiftJLI.CodecError(.internalFailure, "Unexpected successful destination decode.")
        }
        catch let error as SwiftJLI.CodecError where error.category == .unsupportedFeature { }
        print("Independent SwiftJLI consumer: synthetic storage and common API calls passed; no JPEG codec is implemented.")
    }
}
