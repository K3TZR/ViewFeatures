//
//  PhoneCwSettingsCore.swift
//  
//
//  Created by Douglas Adams on 12/31/22.
//

import Foundation
import ComposableArchitecture

import Objects
import Shared

public struct PhoneCwSettingsFeature: ReducerProtocol {
  
  public init() {}
  
  @Dependency(\.apiModel) var apiModel
  
  public struct State: Equatable {
    public init
    (
    )
    {
    }
  }
  
  public enum Action: Equatable {
    // parse & send
    case setFilterBool(Radio.FilterProperty)
    case setFilterInt(Radio.FilterProperty,Int)
    case setTransmitBool(Transmit.Property,Bool)
    case setTransmitString(Transmit.Property,String)
    // parse only
    case setRadioString(Radio.RadioProperty,String)
    // send only
    case sendRadioProperty(Radio.RadioProperty)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    
    case .sendRadioProperty(let property):
      return .run { _ in
        await apiModel.radio?.sendOnly(property)
      }
      
    case .setFilterBool(let type):
      guard type == .cw || type == .voice || type == .digital else { return .none }
      return .run { _ in
        await apiModel.radio?.setAndSend(type, .autoLevel)
      }

    case .setFilterInt(let type, let value):
      guard type == .cw || type == .voice || type == .digital else { return .none }
      return .run { _ in
        await apiModel.radio?.setAndSend(type, .level, String(value))
      }

    case .setRadioString(let property, let value):
      return .run { _ in
        await apiModel.radio?.setOnly(property, value)
      }
      
    case .setTransmitBool(let property, let value):
      return .run { _ in
        await apiModel.transmit.setAndSend(property, value.as1or0)
      }
      
    case .setTransmitString(let property, let value):
      return .run { _ in
        await apiModel.transmit.setAndSend(property, value)
      }
    }
  }
}
