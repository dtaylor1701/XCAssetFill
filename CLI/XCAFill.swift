// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation
import XCAFillLibrary

enum XCAFillError: Error {
  case invalidContentsProperties
}

@main
struct XCAFill: ParsableCommand {
  @Argument
  var sourceIconPath: String

  @Argument
  var assetFolderPath: String?

  mutating func run() throws {
    let contentPathURL = URL(filePath: assetFolderPath ?? FileManager.default.currentDirectoryPath)
    let sourceURL = URL(filePath: sourceIconPath)

    try XCAssetFill.fill(assetsFolderURL: contentPathURL, sourceIconURL: sourceURL)
  }
}
