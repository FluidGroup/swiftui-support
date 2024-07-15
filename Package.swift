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
    .library(name: "SwiftUISupportSizing", targets: ["SwiftUISupportSizing"]),
    .library(name: "SwiftUISupportGeometryEffect", targets: ["SwiftUISupportGeometryEffect"])
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "SwiftUISupport",
      dependencies: [
        "SwiftUISupportSizing",
        "SwiftUISupportGeometryEffect"
      ]
    ),
    .target(name: "SwiftUISupportSizing"),
    .target(name: "SwiftUISupportGeometryEffect"),
    .testTarget(
      name: "SwiftUISupportTests",
      dependencies: ["SwiftUISupport"]
    ),
  ]
)
