//
//  DisplayCore.swift
//  
//
//  Created by Douglas Adams on 12/21/22.
//

import Foundation
import ComposableArchitecture

import Shared

public struct DisplayFeature: ReducerProtocol {
  
  public init() {}
  
  public struct State: Equatable {
    var panadapterId: StreamId

    public init
    (
      panadapterId: StreamId
    )
    {
      self.panadapterId = panadapterId
    }
  }
  
  public enum Action: Equatable {
    case averageLevel(Int)
    case fillLevel(Int)
    case fpsLevel(Int)
    case weightedAverageButton
    case colorGain(Int)
    case lineDurationLevel(Int)
    case autoBlackLevel(Int)
    case autoBlackButton
    case gradientPicker(String)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    
    case .averageLevel(let level):
      print("averageLevel = \(level)")
      return .none

    case .fillLevel(let level):
      print("fillLevel = \(level)")
      return .none

    case .fpsLevel(let level):
      print("fpsLevel = \(level)")
      return .none
    
    case .weightedAverageButton:
      print("weightedAverageButton")
      return .none
    
    case .colorGain(let gain):
      print("colorGain = \(gain)")
      return .none

    case .lineDurationLevel(let level):
      print("lineDurationLevel = \(level)")
      return .none

    case .autoBlackLevel(let level):
      print("autoBlackLevel = \(level)")
      return .none

    case .autoBlackButton:
      print("autoBlackButton")
      return .none
      
    case .gradientPicker(let gradient):
      print("gradientPicker = \(gradient)")
      return .none
    }
  }
}
