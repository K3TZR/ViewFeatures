//
//  SettingsCore.swift
//  
//
//  Created by Douglas Adams on 12/21/22.
//

import Foundation
import ComposableArchitecture

import Shared

public struct SettingsFeature: ReducerProtocol {
  
  public init() {}
  
  public struct State: Equatable {

    public init
    (
    )
    {
    }
  }
  
  public enum Action: Equatable {
    case antSelectionPicker(String)
    case rfGainSlider(Int)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    
    case .antSelectionPicker(let antenna):
      print("antSelectionPicker = \(antenna)")
      return .none

    case .rfGainSlider(let gain):
      print("rfGainSlider = \(gain)")
      return .none
    }
  }
}
