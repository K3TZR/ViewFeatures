//
//  Ph2Core.swift
//  
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import Shared

public struct Ph2Feature: ReducerProtocol {

  public init(){}
  
  public struct State: Equatable {
    
    public init
    (
    )
    {
    }
  }
  
  public enum Action: Equatable {
//    case micBiasButton(Bool)
//    case dexpButton(Bool)
//    case meterInRxButton(Bool)
//    case micBoostButton(Bool)
//    case voxButton(Bool)
//    case levelChange(Transmit.Property, Int)
//    case lowCutChange(Int)
//    case highCutChange(Int)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
//    switch action {
//    case .micBiasButton(let value):
//      state.transmit.transmitSetProperty(.micBiasEnabled, !value)
//      return .none
//
//    case .dexpButton(let value):
//      state.transmit.transmitSetProperty(.companderEnabled, !value)
//      return .none
//
//    case .meterInRxButton(let value):
//      state.transmit.transmitSetProperty(.metInRxEnabled, !value)
//      return .none
//
//    case .micBoostButton(let value):
//      state.transmit.transmitSetProperty(.micBoostEnabled, !value)
//      return .none
//
//    case .voxButton(let value):
//      state.transmit.transmitSetProperty(.voxEnabled, !value)
//      return .none
//
//    case .levelChange(let type, let value):
//      state.transmit.transmitSetProperty(type, value)
//      return .none
//
//    case .lowCutChange(let value):
//      state.transmit.transmitSetProperty(.txFilterLow, value)
//      return .none
//
//    case .highCutChange(let value):
//      state.transmit.transmitSetProperty(.txFilterHigh, value)
//      return .none
//    }
  }
}
