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
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(url: "https://github.com/FluidGroup/swiftui-gesture-velocity", from: "1.0.0")
  ],
  targets: [
    .target(
      name: "SwiftUISupport",
      dependencies: [
        .product(name: "SwiftUIGestureVelocity", package: "swiftui-gesture-velocity"),
      ]
    ),
    .testTarget(
      name: "SwiftUISupportTests",
      dependencies: ["SwiftUISupport"]
    ),
  ]
)
