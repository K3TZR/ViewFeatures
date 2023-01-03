//
//  Ph2Core.swift
//  
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import Objects
import Shared

public struct Ph2Feature: ReducerProtocol {
  public init(){}

  @Dependency(\.apiModel) var apiModel

  public struct State: Equatable {    
    public init() {}
  }
  
  public enum Action: Equatable {
    case micBiasButton
    case dexpButton
    case meterInRxButton
    case micBoostButton
    case voxButton
    case levelSlider(Transmit.Property, Int)
    case txFilterLowCut(Int)
    case txFilterHighCut(Int)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {

    case .dexpButton:
      return .run { _ in
        await apiModel.transmit.parseAndSend(.companderEnabled)
      }

    case .levelSlider(let type, let value):
      return .run { _ in
        await apiModel.transmit.parseAndSend(type, String(value))
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

    case .txFilterHighCut(let value):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.txFilterHigh, String(value))
      }

    case .txFilterLowCut(let value):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.txFilterLow, String(value))
      }

    case .voxButton:
      return .run { _ in
        await apiModel.transmit.parseAndSend(.voxEnabled)
      }
    }
  }
}
