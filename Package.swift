// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ViewFeatures",
  platforms: [.macOS(.v14),],
  
  products: [
    .library(name: "AudioPopover", targets: ["AudioPopover"]),
    .library(name: "ClientSheet", targets: ["ClientSheet"]),
    .library(name: "DaxPanel", targets: ["DaxPanel"]),
    .library(name: "Dax2Panel", targets: ["Dax2Panel"]),
    .library(name: "Flag", targets: ["Flag"]),
    .library(name: "FlagAntennaPopover", targets: ["FlagAntennaPopover"]),
    .library(name: "LoginSheet", targets: ["LoginSheet"]),
    .library(name: "LogViewer", targets: ["LogViewer"]),
    .library(name: "MonitorControl", targets: ["MonitorControl"]),
    .library(name: "Panadapter", targets: ["Panadapter"]),
    .library(name: "Panafall", targets: ["Panafall"]),
    .library(name: "PickerSheet", targets: ["PickerSheet"]),
    .library(name: "SettingsPanel", targets: ["SettingsPanel"]),
    .library(name: "SidePanel", targets: ["SidePanel"]),
    .library(name: "Waterfall", targets: ["Waterfall"]),
  ],
  
  dependencies: [
    // ----- K3TZR -----
    .package(url: "https://github.com/K3TZR/ApiFeatures.git", branch: "main"),
    .package(url: "https://github.com/K3TZR/CustomControls.git", branch: "main"),
    .package(url: "https://github.com/K3TZR/CommonFeatures.git", branch: "main"),
    .package(url: "https://github.com/K3TZR/UtilityFeatures.git", branch: "main"),
    // ----- OTHER -----
    .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "1.0.0"),
  ],
  
  // --------------- Modules ---------------
  targets: [
    // AudioPopover
    .target(name: "AudioPopover", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "RxAVAudioPlayer", package: "UtilityFeatures"),
      .product(name: "SettingsModel", package: "CommonFeatures"),
      .product(name: "SharedModel", package: "CommonFeatures"),
    ]),

    // ClientSheet
    .target(name: "ClientSheet", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "SharedModel", package: "CommonFeatures"),
    ]),
    
    // DaxPanel
    .target( name: "DaxPanel", dependencies: [
      .product(name: "LevelIndicatorView", package: "CustomControls"),
      .product(name: "SettingsModel", package: "CommonFeatures"),
      .product(name: "SharedModel", package: "CommonFeatures"),
      "Flag",
    ]),

    // Dax2Panel
    .target( name: "Dax2Panel", dependencies: [
      .product(name: "LevelIndicatorView", package: "CustomControls"),
      .product(name: "SettingsModel", package: "CommonFeatures"),
      .product(name: "SharedModel", package: "CommonFeatures"),
      .product(name: "DaxRxAudioPlayer", package: "UtilityFeatures"),
      "Flag",
    ]),

    // Flag
    .target(name: "Flag", dependencies: [
      "FlagAntennaPopover",
      .product(name: "ApiIntView", package: "CustomControls"),
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "LevelIndicatorView", package: "CustomControls"),
      .product(name: "SettingsModel", package: "CommonFeatures"),
      .product(name: "SharedModel", package: "CommonFeatures"),
    ]),

    // FlagAntennaPopover
    .target(name: "FlagAntennaPopover", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
    ]),

    // LoginSheet
    .target(name: "LoginSheet", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "SharedModel", package: "CommonFeatures"),
    ]),

    // LogViewer
    .target(name: "LogViewer", dependencies: [
      .product(name: "SettingsModel", package: "CommonFeatures"),
      .product(name: "SharedModel", package: "CommonFeatures"),
    ]),

    // MonitorControl
    .target(name: "MonitorControl", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
    ]),
    
    // Panadapter
    .target(name: "Panadapter", dependencies: [
      "Flag",
      .product(name: "FlexApi", package: "ApiFeatures"),
    ]),
    
    // Panafall
    .target(name: "Panafall", dependencies: [
      "Panadapter",
      "Waterfall",
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "SettingsModel", package: "CommonFeatures"),
    ]),

    // PickerSheet
    .target(name: "PickerSheet", dependencies: [
      .product(name: "Listener", package: "ApiFeatures"),
      .product(name: "SharedModel", package: "CommonFeatures"),
      .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
    ]),

    // SettingsPanel
    .target(name: "SettingsPanel", dependencies: [
      .product(name: "SettingsModel", package: "CommonFeatures"),
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "ApiIntView", package: "CustomControls"),
      .product(name: "ApiStringView", package: "CustomControls"),
    ]),

    // SidePanel
    .target( name: "SidePanel", dependencies: [
      .product(name: "ApiIntView", package: "CustomControls"),
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "SettingsModel", package: "CommonFeatures"),
      .product(name: "SharedModel", package: "CommonFeatures"),
      "Flag",
    ]),

    // Waterfall
    .target(
      name: "Waterfall",
      
      dependencies: [
        .product(name: "FlexApi", package: "ApiFeatures"),
        .product(name: "SettingsModel", package: "CommonFeatures"),
      ],
      resources: [
        .copy("Gradients/Basic.tex"),
        .copy("Gradients/Dark.tex"),
        .copy("Gradients/Deuteranopia.tex"),
        .copy("Gradients/Grayscale.tex"),
        .copy("Gradients/Purple.tex"),
        .copy("Gradients/Tritanopia.tex"),
      ]
    )
  ]
  
  // --------------- Tests ---------------
)
