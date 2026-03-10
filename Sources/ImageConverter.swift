// Adapted from https://stackoverflow.com/questions/45775394/how-to-convert-pdf-to-png-efficiently
import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

public struct ImageFileType: Sendable {
  public var uti: String
  public var fileExtension: String

  public init(uti: String, fileExtension: String) {
    self.uti = uti
    self.fileExtension = fileExtension
  }

  public init(type: UTType, fileExtension: String) {
    self.uti = type.identifier
    self.fileExtension = fileExtension
  }

  // This list can include anything returned by CGImageDestinationCopyTypeIdentifiers()
  // I'm including only the popular formats here
  public static let bmp = ImageFileType(type: .bmp, fileExtension: "bmp")
  public static let gif = ImageFileType(type: .gif, fileExtension: "gif")
  public static let jpg = ImageFileType(type: .jpeg, fileExtension: "jpg")
  public static let png = ImageFileType(type: .png, fileExtension: "png")
  public static let tiff = ImageFileType(type: .tiff, fileExtension: "tiff")
}

public enum ImageConverterError: Error {
  case pdfNotFound
  case pdfEmpty
  case graphicsContextError
  case imageCreationError
  case imageDestinationError
}

public enum ImageConverter {
  public static func convertPDF(
    at sourceURL: URL,
    to destinationURL: URL,
    fileType: ImageFileType = .png,
    width: Double,
    height: Double,
    scale: Double,
    paddingRatio: Double,
    cornerRatio: Double
  ) throws {
    guard let pdfDocument = CGPDFDocument(sourceURL as CFURL) else {
      throw ImageConverterError.pdfNotFound
    }

    // Page number starts at 1, not 0
    guard let pdfPage = pdfDocument.page(at: 1) else {
      throw ImageConverterError.pdfEmpty
    }

    let width = Int(width * scale)
    let height = Int(height * scale)

    let xPadding: Int = Int(paddingRatio * Double(width))
    let yPadding: Int = Int(paddingRatio * Double(height))

    guard
      let context = CGContext(
        data: nil,
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
    else {
      throw ImageConverterError.graphicsContextError
    }

    let mediaBoxRect = pdfPage.getBoxRect(.mediaBox)

    let xScale = CGFloat(width - (xPadding * 2)) / mediaBoxRect.width
    let yScale = CGFloat(height - (yPadding * 2)) / mediaBoxRect.height

    context.interpolationQuality = .high
    context.translateBy(x: CGFloat(xPadding), y: CGFloat(yPadding))

    let xCorner = cornerRatio * CGFloat(width)
    let yCorner = cornerRatio * CGFloat(height)

    let rect = CGRect(
      x: 0,
      y: 0,
      width: width - (xPadding * 2),
      height: height - (yPadding * 2))
    let clipPath = CGPath(
      roundedRect: rect,
      cornerWidth: xCorner,
      cornerHeight: yCorner,
      transform: nil)
    context.addPath(clipPath)
    context.clip()

    context.scaleBy(x: xScale, y: yScale)
    context.drawPDFPage(pdfPage)

    guard let image = context.makeImage() else {
      throw ImageConverterError.imageCreationError
    }

    guard
      let imageDestination = CGImageDestinationCreateWithURL(
        destinationURL as CFURL, fileType.uti as CFString, 1, nil)
    else {
      throw ImageConverterError.imageDestinationError
    }

    CGImageDestinationAddImage(imageDestination, image, nil)
    CGImageDestinationFinalize(imageDestination)
  }
}
