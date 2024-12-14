// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftUISupport",
  platforms: [
    .iOS(.v16),
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
    .library(name: "SwiftUISupportLayout", targets: ["SwiftUISupportLayout"]),
    .library(name: "SwiftUISupportBackport", targets: ["SwiftUISupportBackport"]),
    .library(name: "SwiftUISupportDescribing", targets: ["SwiftUISupportDescribing"]),
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
    .target(name: "SwiftUISupportDescribing"),
    .target(name: "SwiftUISupportBackport"),
    .target(name: "SwiftUISupportSizing"),
    .target(name: "SwiftUISupportLayout"),
    .target(name: "SwiftUISupportGeometryEffect"),
    .testTarget(
      name: "SwiftUISupportTests",
      dependencies: ["SwiftUISupport"]
    ),
  ],
  swiftLanguageModes: [.v6]
)
