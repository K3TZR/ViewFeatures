//
//  RxCore.swift
//  
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import Shared

public struct RxFeature: ReducerProtocol {

  public init() {}
  
  public struct State: Equatable {

    public init(
    )
    {
    }
  }
  
  public enum Action: Equatable {
    case atuEnabledButton
    case memoriesEnabledButton
    case moxButton
    case tuneButton
    case rfPowerSlider(Int)
    case tunePowerSlider(Int)
    case txProfilePicker(String)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    case .atuEnabledButton:
      print("atuEnabledButton")
      return .none

    case .memoriesEnabledButton:
      print("memButton")
      return .none

    case .moxButton:
      print("moxButton")
      return .none

    case .tuneButton:
      print("tuneButton")
      return .none
      
    case .rfPowerSlider(let level):
      print("rfPowerSlider = \(level)")
      return .none

    case .tunePowerSlider(let level):
      print("tunePowerSlider = \(level)")
      return .none
      
    case .txProfilePicker(let profileName):
      print("txProfilePicker = \(profileName)")
      return .none

    }
  }
}
