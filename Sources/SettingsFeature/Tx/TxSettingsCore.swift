//
//  TxSettingsCore.swift
//  
//
//  Created by Douglas Adams on 12/31/22.
//

import Foundation
import ComposableArchitecture

import Objects
import Shared

public struct TxSettingsFeature: ReducerProtocol {
  
  public enum InterlockType {
    case acc
    case rca
  }
                              
  public init() {}
  
  @Dependency(\.apiModel) var apiModel
  
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    // set & send
    case maxPowerLevel(Int)
    case setInterlockState(InterlockType,String)
    case setInterlockBool(Interlock.Property,Bool)
    case setTransmitBool(Transmit.Property,Bool)
    // set only
    case setInterlockInt(Interlock.Property,Int)
    case setInterlockString(Interlock.Property,String)
    // send only
    case sendInterlockProperty(Interlock.Property)
    // other
    case txProfile(String)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    
    case .maxPowerLevel(let level):
      return .run { _ in
        await apiModel.transmit.setAndSend(.maxPowerLevel, String(level))
      }

    case .sendInterlockProperty(let interlockProperty):
      return .run { _ in
        await apiModel.interlock.sendOnly(interlockProperty)
      }
      
    case .setInterlockBool(let property, let value):
      return .run { _ in
        await apiModel.interlock.setAndSend(property, value.as1or0)
      }


    case .setInterlockInt(let property, let value):
      return .run { _ in
        await apiModel.interlock.setOnly(property, String(value))
      }

    case .setInterlockState(let type, let selection):
      var polarity: Bool?
      var enabled: Bool?
      
      switch selection {
      case "Disabled":      enabled = false
      case "Active High":   enabled = true ; polarity = true
      case "Active Low":    enabled = true ; polarity = false
      default:              break
      }
      switch type {
      case .acc:
        return .run { [enabled, polarity] _ in
          if enabled != nil   { await apiModel.interlock.setAndSend(.accTxReqEnabled, enabled!.as1or0) }
          if polarity != nil  { await apiModel.interlock.setAndSend(.accTxReqPolarity, polarity!.as1or0)}
        }

      case .rca:
        return .run { [enabled, polarity] _ in
          if enabled != nil   { await apiModel.interlock.setAndSend(.rcaTxReqEnabled, enabled!.as1or0) }
          if polarity != nil  { await apiModel.interlock.setAndSend(.rcaTxReqPolarity, polarity!.as1or0)}
        }
      }

    case .setInterlockString(let property, let value):
      return .run { _ in
        await apiModel.interlock.setOnly(property, value)
      }

    case .setTransmitBool(let property, let value):
      return .run { _ in
        await apiModel.transmit.setAndSend(property, value.as1or0)
      }
      
    case .txProfile(let name):
      return .run { _ in
        await apiModel.profileLoad("tx", name)
      }
    }
  }
}
