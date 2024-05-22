import Foundation

public class XCAssetFill {
  public static func fill(assetsFolderURL: URL, sourceIconURL: URL) throws {

    let data = try Data(contentsOf: assetsFolderURL.appending(component: "Contents.json"))
    let contents = try JSONDecoder().decode(Contents.self, from: data)

    for image in contents.images {
      if let width = image.widthValue,
        let height = image.heightValue,
        let scale = image.scaleValue
      {
        let destinationURL =
          assetsFolderURL
          .appending(component: image.outputName)
          .appendingPathExtension("png")

        try ImageConverter.convertPDF(
          at: sourceIconURL,
          to: destinationURL,
          fileType: .png,
          width: width,
          height: height,
          scale: scale,
          paddingRatio: image.paddingRatio,
          cornerRatio: image.cornerRatio)
      }
    }
  }
}
