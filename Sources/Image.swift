import CoreGraphics
import Foundation

public enum Idiom: String {
  case mac
  case iPhone = "iphone"
  case iPad = "ipad"
  case iOSMarketing = "ios-marketing"
  case universal
}

public struct Image: Codable {
  public var size: String
  public var scale: String?
  public var idiom: String
  public var platform: String?

  public var outputName: String {
    var nameComponents = [idiom, size]
    var name = "\(idiom)_\(size)_\(scale)"

    if let scale {
      nameComponents.append(scale)
    }

    if let platform {
      nameComponents.append(platform)
    }

    return nameComponents.joined(separator: "_")
  }

  public var paddingRatio: Double {
    guard let idiomValue else { return 0 }

    switch idiomValue {
    case .mac:
      return 0.1
    default:
      return 0
    }
  }

  public var cornerRatio: Double {
    guard let idiomValue else { return 0 }

    switch idiomValue {
    case .mac:
      return 0.2
    default:
      return 0
    }
  }

  public var widthValue: Double? {
    guard let dimensionString = size.split(separator: "x").first else { return nil }

    return Double(dimensionString)
  }

  public var heightValue: Double? {
    let dimensionStrings = size.split(separator: "x")
    guard dimensionStrings.count > 1 else { return nil }

    return Double(dimensionStrings[1])
  }

  public var scaleValue: Double? {
    guard let scale else { return 1 }

    let scaleString = scale.filter({ $0 != "x" })

    return Double(scaleString)
  }

  public var idiomValue: Idiom? {
    Idiom(rawValue: idiom)
  }
}
