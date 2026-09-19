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
