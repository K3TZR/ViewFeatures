//
//  DisplayCore.swift
//  
//
//  Created by Douglas Adams on 12/21/22.
//

import Foundation
import ComposableArchitecture

import Shared

public struct DisplayFeature: ReducerProtocol {
  
  public init() {}
  
  @Dependency(\.apiModel) var apiModel
  
  public struct State: Equatable {
    
    public init() {}
  }
  
  public enum Action: Equatable {
    case averageLevel(Int)
    case fillLevel(Int)
    case fpsLevel(Int)
    case weightedAverageButton
    case colorGain(Int)
    case lineDurationLevel(Int)
    case blackLevel(Int)
    case autoBlackButton
    case gradientPicker(Int)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
      
    case .averageLevel(let level):
      return .run { _ in
        if let panadapterId = await apiModel.activePanadapter?.id {
          await apiModel.panadapters[id: panadapterId]?.parseAndSend(.average, String(level))
        }
      }

    case .fillLevel(let level):
      return .run { _ in
        if let panadapterId = await apiModel.activePanadapter?.id {
          await apiModel.panadapters[id: panadapterId]?.setFillLevel(level)
        }
      }
      
    case .fpsLevel(let level):
      return .run { _ in
        if let panadapterId = await apiModel.activePanadapter?.id {
          await apiModel.panadapters[id: panadapterId]?.parseAndSend(.fps, String(level))
        }
      }

    case .weightedAverageButton:
      return .run { _ in
        if let panadapterId = await apiModel.activePanadapter?.id {
          await apiModel.panadapters[id: panadapterId]?.parseAndSend(.weightedAverageEnabled)
        }
      }

    case .colorGain(let gain):
      return .run { _ in
        if let waterfallId = await apiModel.activePanadapter?.waterfallId {
          await apiModel.waterfalls[id: waterfallId]?.parseAndSend(.colorGain, String(gain))
        }
      }
      
    case .lineDurationLevel(let duration):
      return .run { _ in
        if let waterfallId = await apiModel.activePanadapter?.waterfallId {
          await apiModel.waterfalls[id: waterfallId]?.parseAndSend(.lineDuration, String(duration))
        }
      }
      
    case .blackLevel(let level):
      return .run { _ in
        if let waterfallId = await apiModel.activePanadapter?.waterfallId {
          await apiModel.waterfalls[id: waterfallId]?.parseAndSend(.blackLevel, String(level))
        }
      }
      
    case .autoBlackButton:
      return .run { _ in
        if let waterfallId = await apiModel.activePanadapter?.waterfallId {
          await apiModel.waterfalls[id: waterfallId]?.parseAndSend(.autoBlackEnabled)
        }
      }
      
    case .gradientPicker(let index):
      return .run { _ in
        if let waterfallId = await apiModel.activePanadapter?.waterfallId {
          await apiModel.waterfalls[id: waterfallId]?.parseAndSend(.gradientIndex, String(index))
        }
      }
    }
  }
}
