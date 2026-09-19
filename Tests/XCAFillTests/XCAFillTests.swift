import Testing
import Foundation
import CoreGraphics
import ImageIO
@testable import XCAFillLibrary

@Suite("XCAFill Tests")
struct XCAFillTests {
    @Test func example() {
        // Basic test to verify it builds and runs
        #expect(true)
    }

    @Test func testConvertImage() throws {
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let sourceURL = tempDir.appendingPathComponent("source.png")
        let destURL = tempDir.appendingPathComponent("dest.png")

        // Create a simple test PNG image
        let width = 100
        let height = 100
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
            let cgImage = context.makeImage(),
            let destination = CGImageDestinationCreateWithURL(sourceURL as CFURL, "public.png" as CFString, 1, nil)
        else {
            #expect(Bool(false), "Failed to create source image")
            return
        }
        CGImageDestinationAddImage(destination, cgImage, nil)
        CGImageDestinationFinalize(destination)

        #expect(FileManager.default.fileExists(atPath: sourceURL.path))

        try ImageConverter.convertImage(
            at: sourceURL,
            to: destURL,
            fileType: .png,
            width: 50,
            height: 50,
            scale: 2.0,
            paddingRatio: 0.0,
            cornerRatio: 0.0
        )

        #expect(FileManager.default.fileExists(atPath: destURL.path))
    }
}
