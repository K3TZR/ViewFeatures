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
    case accTxButton
    case accInterlock(String)
    case accTxDelay(Int)
    case hardwareAlcButton
    case maxPowerLevel(Int)
    case rcaInterlock(String)
    case rcaTx1Button
    case rcaTx1Delay(Int)
    case rcaTx2Button
    case rcaTx2Delay(Int)
    case rcaTx3Button
    case rcaTx3Delay(Int)
    case timeout(Int)
    case txInhibitButton
    case txInWaterfallButton
    case txProfile(UUID)
    case txDelay(Int)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    
    case .accInterlock(let selection):
      var polarity: Bool?
      var enabled: Bool?
      
      switch selection {
      case "Disabled":      enabled = false
      case "Active High":   enabled = true ; polarity = true
      case "Active Low":    enabled = true ; polarity = false
      default:              break
      }
      
      return .run { [enabled, polarity] _ in
        if enabled != nil   { await apiModel.interlock.parseAndSend(.accTxReqEnabled, enabled!.as1or0) }
        if polarity != nil  { await apiModel.interlock.parseAndSend(.accTxReqPolarity, polarity!.as1or0)}
      }
      
    case .accTxButton:
      return .run { _ in
        await apiModel.interlock.parseAndSend(.accTxEnabled)
      }

    case .accTxDelay(let delay):
      return .run { _ in
        await apiModel.interlock.parseAndSend(.accTxDelay, String(delay))
      }

    case .hardwareAlcButton:
      return .run { _ in
        await apiModel.transmit.parseAndSend(.hwAlcEnabled)
      }

    case .maxPowerLevel(let level):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.maxPowerLevel, String(level))
      }

    case .rcaInterlock(let selection):
      var polarity: Bool?
      var enabled: Bool?
      
      switch selection {
      case "Disabled":      enabled = false
      case "Active High":   enabled = true ; polarity = true
      case "Active Low":    enabled = true ; polarity = false
      default:              break
      }
      
      return .run { [enabled, polarity] _ in
        if enabled != nil   { await apiModel.interlock.parseAndSend(.rcaTxReqEnabled, enabled!.as1or0) }
        if polarity != nil  { await apiModel.interlock.parseAndSend(.rcaTxReqPolarity, polarity!.as1or0)}
      }

    case .rcaTx1Button:
      return .run { _ in
        await apiModel.interlock.parseAndSend(.tx1Enabled)
      }

    case .rcaTx1Delay(let delay):
      return .run { _ in
        await apiModel.interlock.parseAndSend(.tx1Delay, String(delay))
      }

    case .rcaTx2Button:
      return .run { _ in
        await apiModel.interlock.parseAndSend(.tx2Enabled)
      }

    case .rcaTx2Delay(let delay):
      return .run { _ in
        await apiModel.interlock.parseAndSend(.tx2Delay, String(delay))
      }

    case .rcaTx3Button:
      return .run { _ in
        await apiModel.interlock.parseAndSend(.tx3Enabled)
      }

    case .rcaTx3Delay(let delay):
      return .run { _ in
        await apiModel.interlock.parseAndSend(.tx3Delay, String(delay))
      }

    case .timeout(let timeout):
      return .run { _ in
        await apiModel.interlock.parseAndSend(.timeout, String(timeout))
      }

    case .txInhibitButton:
      return .run { _ in
        await apiModel.interlock.parseAndSend(.txAllowed)
      }

    case .txInWaterfallButton:
      return .run { _ in
        await apiModel.transmit.parseAndSend(.txInWaterfallEnabled)
      }

    case .txProfile(let id):
      return .none
      
    case .txDelay(let delay):
      return .run { _ in
        await apiModel.interlock.parseAndSend(.txDelay, String(delay))
      }
    }
  }
}
