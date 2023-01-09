// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ViewFeatures",
  platforms: [
    .iOS(.v15),
    .macOS(.v13),
  ],
  products: [
    .library(name: "AntennaFeature", targets: ["AntennaFeature"]),
    .library(name: "BandFeature", targets: ["BandFeature"]),
    .library(name: "ClientFeature", targets: ["ClientFeature"]),
    .library(name: "CwFeature", targets: ["CwFeature"]),
    .library(name: "DaxFeature", targets: ["DaxFeature"]),
    .library(name: "DisplayFeature", targets: ["DisplayFeature"]),
    .library(name: "EqFeature", targets: ["EqFeature"]),
    .library(name: "LeftSideFeature", targets: ["LeftSideFeature"]),
    .library(name: "LevelIndicatorView", targets: ["LevelIndicatorView"]),
    .library(name: "LoginFeature", targets: ["LoginFeature"]),
    .library(name: "LogFeature", targets: ["LogFeature"]),
    .library(name: "Ph1Feature", targets: ["Ph1Feature"]),
    .library(name: "Ph2Feature", targets: ["Ph2Feature"]),
    .library(name: "PickerFeature", targets: ["PickerFeature"]),
    .library(name: "ProgressFeature", targets: ["ProgressFeature"]),
    .library(name: "RightSideFeature", targets: ["RightSideFeature"]),
    .library(name: "RxFeature", targets: ["RxFeature"]),
    .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
    .library(name: "TxFeature", targets: ["TxFeature"]),
  ],
  dependencies: [
    .package(url: "https://github.com/K3TZR/ApiFeatures.git", from: "1.11.1"),
    .package(url: "https://github.com/K3TZR/SharedFeatures.git", from: "1.6.1"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.42.0"),
  ],
  targets: [
    // --------------- Modules ---------------
    // AntennaFeature
    .target(name: "AntennaFeature", dependencies: [
      .product(name: "Objects", package: "ApiFeatures"),
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // BandFeature
    .target(name: "BandFeature", dependencies: [
      .product(name: "Objects", package: "ApiFeatures"),
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // ClientFeature
    .target(name: "ClientFeature", dependencies: [
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // CwFeature
    .target(name: "CwFeature", dependencies: [
      "LevelIndicatorView",
      .product(name: "Objects", package: "ApiFeatures"),
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // DaxFeature
    .target(name: "DaxFeature", dependencies: [
      .product(name: "Objects", package: "ApiFeatures"),
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // DisplayFeature
    .target(name: "DisplayFeature", dependencies: [
      .product(name: "Objects", package: "ApiFeatures"),
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // EqFeature
    .target(name: "EqFeature", dependencies: [
      .product(name: "Objects", package: "ApiFeatures"),
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // LeftSideFeature
    .target(name: "LeftSideFeature",  dependencies: [
      "AntennaFeature",
      "BandFeature",
      "DaxFeature",
      "DisplayFeature",
      .product(name: "Objects", package: "ApiFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // LevelIndicatorView
    .target(name: "LevelIndicatorView", dependencies: [
    ]),
    
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

    // Ph1Feature
    .target(name: "Ph1Feature", dependencies: [
      "LevelIndicatorView",
      .product(name: "Objects", package: "ApiFeatures"),
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),

    // Ph2Feature
    .target(name: "Ph2Feature", dependencies: [
      .product(name: "Objects", package: "ApiFeatures"),
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),

    // PickerFeature
    .target(name: "PickerFeature", dependencies: [
      .product(name: "Listener", package: "ApiFeatures"),
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // ProgressFeature
    .target(name: "ProgressFeature",  dependencies: [
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // RightSideFeature
    .target(name: "RightSideFeature",  dependencies: [
      "CwFeature",
      "EqFeature",
      "Ph1Feature",
      "Ph2Feature",
      "RxFeature",
      "TxFeature",
      .product(name: "Objects", package: "ApiFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // RxFeature
    .target(name: "RxFeature", dependencies: [
      "LevelIndicatorView",
      .product(name: "Objects", package: "ApiFeatures"),
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),

    // SettingsFeature
    .target(name: "SettingsFeature", dependencies: [
      .product(name: "Objects", package: "ApiFeatures"),
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // TxFeature
    .target(name: "TxFeature", dependencies: [
      "LevelIndicatorView",
      .product(name: "Objects", package: "ApiFeatures"),
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
  ]
)
