// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftUISupport",
  platforms: [
    .iOS(.v14),
    .macOS(.v10_15),
    .watchOS(.v6),
    .tvOS(.v13),
  ],
  products: [
    .library(
      name: "SwiftUISupport",
      targets: ["SwiftUISupport"]
    ),
    .library(name: "SwiftUISupportSizing", targets: ["SwiftUISupportSizing"])
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "SwiftUISupport",
      dependencies: [
      ]
    ),
    .target(name: "SwiftUISupportSizing"),
    .testTarget(
      name: "SwiftUISupportTests",
      dependencies: ["SwiftUISupport"]
    ),
  ]
)
