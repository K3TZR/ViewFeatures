// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ViewFeatures",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
  ],
  products: [
    .library(name: "ClientFeature", targets: ["ClientFeature"]),
    .library(name: "EqFeature", targets: ["EqFeature"]),
    .library(name: "LevelIndicatorView", targets: ["LevelIndicatorView"]),
    .library(name: "LoginFeature", targets: ["LoginFeature"]),
    .library(name: "LogFeature", targets: ["LogFeature"]),
    .library(name: "PickerFeature", targets: ["PickerFeature"]),
    .library(name: "ProgressFeature", targets: ["ProgressFeature"]),
  ],
  dependencies: [
    .package(url: "https://github.com/K3TZR/SharedFeatures.git", from: "1.3.1"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.42.0"),
  ],
  targets: [
    // --------------- Modules ---------------
    // ClientFeature
    .target(name: "ClientFeature", dependencies: [
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // EqFeature
    .target(name: "EqFeature", dependencies: [
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // LevelIndicatorView
    .target(name: "LevelIndicatorView", dependencies: []),
    
    // LoginFeature
    .target(name: "LoginFeature", dependencies: [
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // LogFeature
    .target(name: "LogFeature", dependencies: [
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),

    // PickerFeature
    .target(name: "PickerFeature", dependencies: [
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // ProgressFeature
      .target(name: "ProgressFeature",  dependencies: [
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
  ]
)
