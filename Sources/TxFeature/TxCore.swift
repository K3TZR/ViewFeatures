//
//  TxCore.swift
//
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import Shared

public struct TxFeature: ReducerProtocol {

  public init() {}
  
  @Dependency(\.apiModel) var apiModel
  
  public struct State: Equatable {

    public init(
    )
    {
    }
  }
  
  public enum Action: Equatable {
    case atuEnabledButton(Bool)
    case memoriesEnabledButton(Bool)
    case moxButton(Bool)
    case tuneButton(Bool)
    case rfPowerSlider(Int)
    case tunePowerSlider(Int)
    case txProfilePicker(String)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    case .atuEnabledButton(let state):
//      return .run { _ in
//        await apiModel.transmit.parseAndSend(.atuEnabled, state.as1or0)
//      }
      return .none

    case .memoriesEnabledButton(let state):
      return .run { _ in
        await apiModel.transmit.sendAtu("memories_enabled", state.as1or0)
      }

    case .moxButton(let state):
      return .run { _ in
        await apiModel.transmit.sendMox(state)
      }

    case .tuneButton(let state):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.tune, state.as1or0)
      }

    case .rfPowerSlider(let level):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.rfPower, String(level))
      }

    case .tunePowerSlider(let level):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.tunePower, String(level))
      }

    case .txProfilePicker(let selection):
      return .run { _ in
        await apiModel.profiles[id: "tx"]?.parseAndSend(.current, selection)
      }
    }
  }
}
