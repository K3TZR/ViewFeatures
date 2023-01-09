//
//  RadioSettingsCore.swift
//  
//
//  Created by Douglas Adams on 12/31/22.
//

import Foundation
import ComposableArchitecture

import Objects
import Shared

public struct RadioSettingsFeature: ReducerProtocol {

  public init() {
  }
  
  @Dependency(\.apiModel) var apiModel
  
  public struct State: Equatable {
    
    public init() {}
  }
  
  public enum Action: Equatable {
    // parse & send
    case setRadioBool(Radio.RadioProperty)
    // parse only
    case setRadioString(Radio.RadioProperty,String)
    // send only
    case sendRadioProperty(Radio.RadioProperty)
    // other
    case calibrateButton
    case singleClickButton
    case sliceMinimizedButton
  }
  
  public var body: some ReducerProtocol<RadioSettingsFeature.State, RadioSettingsFeature.Action> {
    
    Reduce {state, action in
      switch action {

      case .calibrateButton:
        return .run { _ in
          await apiModel.radio?.radioCalibrateCmd()
        }
        
      case .setRadioBool(let property):
        return .run { _ in
          await apiModel.radio?.setOnly(property)
        }

      case .sendRadioProperty(let property):
        return .run { _ in
          await apiModel.radio?.sendOnly(property)
        }
        
      case .setRadioString(let property, let value):
        return .run { _ in
          await apiModel.radio?.setOnly(property, value)
        }

      case .singleClickButton:
        // FIXME:
        return .none
        
      case .sliceMinimizedButton:
        // FIXME:
        return .none
      }
    }
  }
}
