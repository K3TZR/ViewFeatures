//
//  File.swift
//  
//
//  Created by Douglas Adams on 12/31/22.
//

import ComposableArchitecture
import Foundation
import SwiftUI

import Objects
import Shared

public struct ColorsSettingsFeature: ReducerProtocol {
  
  public init() {}
  
  let defaultColors: Dictionary<String,Color> =
  [
    "background": .black,
    "dbLegend": .green,
    "dbLines": .white.opacity(0.3),
    "frequencyLegend": .green,
    "gridLines": .white.opacity(0.3),
    "marker": .yellow,
    "markerEdge": .red.opacity(0.2),
    "markerSegment": .white.opacity(0.2),
    "sliceActive": .red.opacity(0.6),
    "sliceFilter": .white.opacity(0.3),
    "sliceInactive": .yellow.opacity(0.6),
    "spectrum": .white,
    "spectrumFill": .white.opacity(0.2),
    "tnfActive": .green.opacity(0.2),
    "tnfInactive": .yellow.opacity(0.2),
  ]

  @Dependency(\.apiModel) var apiModel
  
  public struct State: Equatable {
    var background: Color { didSet { UserDefaults.standard.set(background.rawValue, forKey: "background") } }
    var frequencyLegend: Color { didSet { UserDefaults.standard.set(frequencyLegend.rawValue, forKey: "frequencyLegend") } }
    var dbLegend: Color { didSet { UserDefaults.standard.set(dbLegend.rawValue, forKey: "dbLegend") } }
    var dbLines: Color { didSet { UserDefaults.standard.set(dbLines.rawValue, forKey: "dbLines") } }
    var gridLines: Color { didSet { UserDefaults.standard.set(gridLines.rawValue, forKey: "gridLines") } }
    var marker: Color { didSet { UserDefaults.standard.set(marker.rawValue, forKey: "marker") } }
    var markerEdge: Color { didSet { UserDefaults.standard.set(markerEdge.rawValue, forKey: "markerEdge") } }
    var markerSegment: Color { didSet { UserDefaults.standard.set(markerSegment.rawValue, forKey: "markerSegment") } }
    var sliceActive: Color { didSet { UserDefaults.standard.set(sliceActive.rawValue, forKey: "sliceActive") } }
    var sliceFilter: Color { didSet { UserDefaults.standard.set(sliceFilter.rawValue, forKey: "sliceFilter") } }
    var sliceInactive: Color { didSet { UserDefaults.standard.set(sliceInactive.rawValue, forKey: "sliceInactive") } }
    var spectrum: Color { didSet { UserDefaults.standard.set(spectrum.rawValue, forKey: "spectrum") } }
    var spectrumFill: Color { didSet { UserDefaults.standard.set(spectrumFill.rawValue, forKey: "spectrumFill") } }
    var tnfActive: Color { didSet { UserDefaults.standard.set(tnfActive.rawValue, forKey: "tnfActive") } }
    var tnfInactive: Color { didSet { UserDefaults.standard.set(tnfInactive.rawValue, forKey: "tnfInactive") } }

    public init
    (
      background: Color = Color(rawValue: UserDefaults.standard.string(forKey: "background") ?? "") ?? Color(.black),
      frequencyLegend: Color  = Color(rawValue: UserDefaults.standard.string(forKey: "frequencyLegend") ?? "") ?? Color(.green),
      dbLegend: Color = Color(rawValue: UserDefaults.standard.string(forKey: "dbLegend") ?? "") ?? Color(.green),
      dbLines: Color = Color(rawValue: UserDefaults.standard.string(forKey: "dbLines") ?? "") ?? Color(.white).opacity(0.3),
      gridLines: Color = Color(rawValue: UserDefaults.standard.string(forKey: "gridLines") ?? "") ?? Color(.white).opacity(0.3),
      marker: Color = Color(rawValue: UserDefaults.standard.string(forKey: "marker") ?? "") ?? Color(.yellow),
      markerEdge: Color = Color(rawValue: UserDefaults.standard.string(forKey: "markerEdge") ?? "") ?? Color(.red).opacity(0.2),
      markerSegment: Color = Color(rawValue: UserDefaults.standard.string(forKey: "markerSegment") ?? "") ?? Color(.white).opacity(0.2),
      sliceActive: Color = Color(rawValue: UserDefaults.standard.string(forKey: "sliceActive") ?? "") ?? Color(.red).opacity(0.6),
      sliceFilter: Color = Color(rawValue: UserDefaults.standard.string(forKey: "sliceFilter") ?? "") ?? Color(.white).opacity(0.3),
      sliceInactive: Color = Color(rawValue: UserDefaults.standard.string(forKey: "sliceInactive") ?? "") ?? Color(.yellow).opacity(0.6),
      spectrum: Color = Color(rawValue: UserDefaults.standard.string(forKey: "spectrum") ?? "") ?? Color(.white),
      spectrumFill: Color = Color(rawValue: UserDefaults.standard.string(forKey: "spectrumFill") ?? "") ?? Color(.white).opacity(0.2),
      tnfActive: Color = Color(rawValue: UserDefaults.standard.string(forKey: "tnfActive") ?? "") ?? Color(.green).opacity(0.2),
      tnfInactive: Color = Color(rawValue: UserDefaults.standard.string(forKey: "tnfInactive") ?? "") ?? Color(.yellow).opacity(0.2)
    )
    
    {
      self.background = background
      self.frequencyLegend = frequencyLegend
      self.dbLegend = dbLegend
      self.dbLines = dbLines
      self.gridLines = gridLines
      self.marker = marker
      self.markerEdge = markerEdge
      self.markerSegment = markerSegment
      self.sliceActive = sliceActive
      self.sliceFilter = sliceFilter
      self.sliceInactive = sliceInactive
      self.spectrum = spectrum
      self.spectrumFill = spectrumFill
      self.tnfActive = tnfActive
      self.tnfInactive = tnfInactive
    }
  }
  
  public enum Action: Equatable {
    case setDefaults
    case color(WritableKeyPath<ColorsSettingsFeature.State, Color>, Color)
    case reset(WritableKeyPath<ColorsSettingsFeature.State, Color>, String)
    case resetAll
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    
    case .color(let keyPath, let color):
      state[keyPath: keyPath] = color
      return .none
      
    case .reset(let keyPath, let name):
      if let color = defaultColors[name] {
        UserDefaults.standard.set(color.rawValue, forKey: name)
        state[keyPath: keyPath] = color
      }
      return .none
      
    case .resetAll:
      for color in defaultColors {
        UserDefaults.standard.set(color.value.rawValue, forKey: color.key)
      }
      return .none
      
    case .setDefaults:
      for item in defaultColors {
        UserDefaults.standard.register(defaults: [item.key: item.value.rawValue])
      }
      return .none
    }
  }
}

extension Color: RawRepresentable {
  public init?(rawValue: String) {
    guard let data = Data(base64Encoded: rawValue) else {
      self = .pink
      return
    }
    
    do {
      let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSColor ?? .systemPink
      self = Color(color)
    } catch {
      self = .pink
    }
  }
  
  public var rawValue: String {
    do {
      let data = try NSKeyedArchiver.archivedData(withRootObject: NSColor(self), requiringSecureCoding: false) as Data
      return data.base64EncodedString()
    } catch {
      return ""
    }
  }
}
