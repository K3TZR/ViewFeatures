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
    case micBiasButton
    case micBoostButton
    case meterInRxButton
    case iambicButton
    case iambicMode(String)
    case swapPaddlesButton
    case cwSideband(String)
    case cwSyncCwxButton
    case rttyMark(Int)
    case filterVoiceAutoButton
    case filterVoiceLevel(Int)
    case filterCwAutoButton
    case filterCwLevel(Int)
    case filterDigitalAutoButton
    case filterDigitalLevel(Int)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    
    case .cwSideband(let sideband):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.cwlEnabled, sideband)
      }

    case .cwSyncCwxButton:
      return .run { _ in
        await apiModel.transmit.parseAndSend(.cwSyncCwxEnabled)
      }

    case .filterCwAutoButton:
      return .run { _ in
        await apiModel.radio?.parseAndSend(.cw, .autoLevel)
      }

    case .filterCwLevel(let level):
      return .run { _ in
        await apiModel.radio?.parseAndSend(.cw, .level, String(level))
      }

    case .filterDigitalAutoButton:
      return .run { _ in
        await apiModel.radio?.parseAndSend(.digital, .autoLevel)
      }

    case .filterDigitalLevel(let level):
      return .run { _ in
        await apiModel.radio?.parseAndSend(.digital, .level, String(level))
      }

    case .filterVoiceAutoButton:
      return .run { _ in
        await apiModel.radio?.parseAndSend(.voice, .autoLevel)
      }

    case .filterVoiceLevel(let level):
      return .run { _ in
        await apiModel.radio?.parseAndSend(.voice, .level, String(level))
      }

    case .iambicButton:
      return .run { _ in
        await apiModel.transmit.parseAndSend(.cwIambicEnabled)
      }
      
    case .iambicMode(let mode):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.cwIambicMode, mode)
      }

    case .meterInRxButton:
      return .run { _ in
        await apiModel.transmit.parseAndSend(.meterInRxEnabled)
      }

    case .micBiasButton:
      return .run { _ in
        await apiModel.transmit.parseAndSend(.micBiasEnabled)
      }

    case .micBoostButton:
      return .run { _ in
        await apiModel.transmit.parseAndSend(.micBoostEnabled)
      }

    case .rttyMark(let mark):
      return .run { _ in
        await apiModel.radio?.parseAndSend(.rttyMark, String(mark))
      }

    case .swapPaddlesButton:
      return .run { _ in
        await apiModel.transmit.parseAndSend(.cwSwapPaddles)
      }
    }
  }
}
