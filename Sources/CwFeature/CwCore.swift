//
//  CwCore.swift
//  
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import ApiModel
import Shared

public struct CwFeature: ReducerProtocol {

  public init() {}
  
  public struct State: Equatable {
    var transmit: Transmit

    public init(
      transmit: Transmit
    )
    {
      self.transmit = transmit
    }
  }
  
  public enum Action: Equatable {
    case breakinButton(Bool)
    case delayLevel(Int)
    case iambicButton(Bool)
    case pitchChange(Int)
    case sidetoneButton(Bool)
    case sidetoneGain(Int)
    case sidetonePan(Int)
    case speedLevel(Int)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {

    case .breakinButton(let value):
      state.transmit.transmitSetProperty(.cwBreakInEnabled, value)
      return .none
      
    case .delayLevel(let value):
      state.transmit.transmitSetProperty(.cwBreakInDelay, value)
      return .none

    case .iambicButton(let value):
      state.transmit.transmitSetProperty(.cwIambicEnabled, value)
      return .none

    case .pitchChange(let value):
      state.transmit.transmitSetProperty(.cwPitch, value)
      return .none

    case .sidetoneButton(let value):
      state.transmit.transmitSetProperty(.cwSidetoneEnabled, value)
      return .none

    case .sidetoneGain(let value):
      state.transmit.transmitSetProperty(.cwMonitorGain, value)
      return .none

    case .sidetonePan(let value):
      state.transmit.transmitSetProperty(.cwMonitorPan, value)
      return .none

    case .speedLevel(let value):
      state.transmit.transmitSetProperty(.cwSpeed, value)
      return .none
    }
  }
}
