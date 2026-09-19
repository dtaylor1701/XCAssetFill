import Foundation

public struct ContentsInfo: Codable {
  public var author: String
  public var version: Int

  public init(author: String = "xcode", version: Int = 1) {
    self.author = author
    self.version = version
  }
}

public struct Contents: Codable {
  public var images: [Image]
  public var info: ContentsInfo?

  public init(images: [Image], info: ContentsInfo? = ContentsInfo()) {
    self.images = images
    self.info = info
  }
}
