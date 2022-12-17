//
//  Ph1Core.swift
//
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import Shared

public struct Ph1Feature: ReducerProtocol {

  public init() {}
  
  public struct State: Equatable {

    public init(
    )
    {
    }
  }
  
  public enum Action: Equatable {
    case micProfilePicker(String)
    case micSelectionPicker(String)
    case micLevelSlider(Int)
    case micAccButton(Bool)
    case speechProcessorLevelSlider(Int)
    case speechProcessorButton(Bool)
    case daxButton(Bool)
    case txMonitorButton(Bool)
    case ssbMonitorGainSlider(Int)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    case .micProfilePicker(let name):
      print("micProfile = \(name)")
      return .none
      
    case .micSelectionPicker(let name):
      print("micSelection = \(name)")
      return .none

    case .micAccButton(let enabled):
      print("micAccButton = \(enabled)")
      return .none

    case .speechProcessorLevelSlider(let level):
      print("speechProcessorLevelSlider = \(level)")
      return .none

    case .micLevelSlider(let level):
      print("micLevelSlider = \(level)")
      return .none

    case .daxButton(let enabled):
      print("daxButton = \(enabled)")
      return .none

    case .speechProcessorButton(let enabled):
      print("speechProcessorButton = \(enabled)")
      return .none

    case .txMonitorButton(let enabled):
      print("txMonitorButton = \(enabled)")
      return .none

    case .ssbMonitorGainSlider(let level):
      print("ssbMonitorGainSlider = \(level)")
      return .none
      
     //    case .levelChange(let type, let value):
      //      Equalizer.setEqProperty(state.rxSelected ? "rxsc" : "txsc", type, value)
      //      return .none
      //
      //    case .rxButton:
      //      state.rxSelected.toggle()
      //      state.txSelected = !state.rxSelected
      //      print("rxSelected = \(state.rxSelected)")
      //      return .none
      //
      //    case .txButton:
      //      state.txSelected .toggle()
      //      state.rxSelected = !state.txSelected
      //      print("txSelected = \(state.txSelected)")
      //      return .none
      //    }
    }
  }
}
