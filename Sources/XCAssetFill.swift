import Foundation

public class XCAssetFill {
  public static func fill(assetsFolderURL: URL, sourceIconURL: URL) throws {

    let contentsURL = assetsFolderURL.appending(component: "Contents.json")
    let data = try Data(contentsOf: contentsURL)
    var contents = try JSONDecoder().decode(Contents.self, from: data)

    for i in 0..<contents.images.count {
      let image = contents.images[i]
      if let width = image.widthValue,
        let height = image.heightValue,
        let scale = image.scaleValue
      {
        let filename = image.filename ?? "\(image.outputName).png"
        contents.images[i].filename = filename

        let destinationURL = assetsFolderURL.appending(component: filename)

        let ext = sourceIconURL.pathExtension.lowercased()
        if ext == "pdf" {
          try ImageConverter.convertPDF(
            at: sourceIconURL,
            to: destinationURL,
            fileType: .png,
            width: width,
            height: height,
            scale: scale,
            paddingRatio: image.paddingRatio,
            cornerRatio: image.cornerRatio)
        } else {
          try ImageConverter.convertImage(
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

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    let updatedData = try encoder.encode(contents)
    try updatedData.write(to: contentsURL, options: .atomic)
  }
}
