//
//  DaxCore.swift
//  
//
//  Created by Douglas Adams on 12/21/22.
//

import Foundation
import ComposableArchitecture

import Shared

public struct DaxFeature: ReducerProtocol {
  
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
