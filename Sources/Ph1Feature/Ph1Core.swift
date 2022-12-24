//
//  Ph1Core.swift
//
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import Shared

public struct Ph1Feature: ReducerProtocol {

  public init() {}
  
  @Dependency(\.apiModel) var apiModel
  
  public struct State: Equatable {

    public init(
    )
    {
    }
  }
  
  public enum Action: Equatable {
    case daxButton(Bool)
    case micAccButton(Bool)
    case micLevelSlider(Int)
    case micProfilePicker(String)
    case micSelectionPicker(String)
    case speechProcessorButton(Bool)
    case speechProcessorLevelSlider(Int)
    case ssbMonitorGainSlider(Int)
    case ssbMonitorPanSlider(Int)
    case txMonitorButton(Bool)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {

    case .daxButton(let enabled):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.daxEnabled, enabled.as1or0)
      }

    case .micAccButton(let enabled):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.micAccEnabled, enabled.as1or0)
      }

    case .micLevelSlider(let level):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.micLevel, String(level))
      }

    case .micSelectionPicker(let selection):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.micSelection, selection)
      }

    case .micProfilePicker(let selection):
      return .run { _ in
        await apiModel.profiles[id: "mic"]?.parseAndSend(.current, selection)
      }

    case .speechProcessorButton(let enabled):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.speechProcessorEnabled, enabled.as1or0)
      }

    case .speechProcessorLevelSlider(let level):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.speechProcessorLevel, String(level))
      }

    case .ssbMonitorGainSlider(let gain):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.ssbMonitorGain, String(gain))
      }

    case .ssbMonitorPanSlider(let value):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.ssbMonitorPan, String(value))
      }

    case .txMonitorButton(let enabled):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.txMonitorEnabled, enabled.as1or0)
      }
    }
  }
}
