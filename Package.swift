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
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "SwiftUISupport",
      targets: ["SwiftUISupport"]
    )
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "SwiftUISupport",
      dependencies: [
      ]
    ),
    .testTarget(
      name: "SwiftUISupportTests",
      dependencies: ["SwiftUISupport"]
    ),
  ]
)
