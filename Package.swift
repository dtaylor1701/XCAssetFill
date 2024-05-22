// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "XCAFill",
  platforms: [.macOS(.v13)],
  products: [
    .library(
      name: "XCAFillLibrary",
      targets: ["XCAFillLibrary"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .executableTarget(
      name: "XCAFill",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        "XCAFillLibrary",
      ],
      path: "CLI"
    ),
    .target(
      name: "XCAFillLibrary",
      path: "Sources"
    ),
  ]
)
