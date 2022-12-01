//
//  Ph1Core.swift
//
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import ApiModel
import Shared

public struct Ph1Feature: ReducerProtocol {

  public init() {}
  
  public struct State: Equatable {
//    var equalizer: Equalizer
//    var txSelected: Bool
//    var rxSelected: Bool

    public init(
//      equalizer: Equalizer,
//      txSelected: Bool
    )
    {
//      self.equalizer = equalizer
//      self.txSelected = txSelected
//      self.rxSelected = !txSelected
    }
  }
  
  public enum Action: Equatable {
//    case eqEnabledButton
//    case rxButton
//    case txButton
//    case levelChange(Equalizer.Property, Double)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
//    switch action {
//    case .eqEnabledButton:
//      state.equalizer.eqEnabled.toggle()
//      print("EqEnabled = \(state.equalizer.eqEnabled)")
//      return .none
//
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
    return .none
  }
}
