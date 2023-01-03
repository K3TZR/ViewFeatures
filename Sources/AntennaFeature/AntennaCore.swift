//
//  AntennaCore.swift
//  
//
//  Created by Douglas Adams on 12/21/22.
//

import Foundation
import ComposableArchitecture

import Shared

public struct AntennaFeature: ReducerProtocol {
  
  public init() {}
  
  @Dependency(\.apiModel) var apiModel
  
  public struct State: Equatable {
    
    public init() {}
  }
  
  public enum Action: Equatable {
    case antSelectionPicker(String)
    case loopAButton
    case rfGainSlider(Int)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
      
    case .antSelectionPicker(let antenna):
      return .run { _ in
        if let panadapterId = await apiModel.activePanadapter?.id{
          await apiModel.panadapters[id: panadapterId]?.parseAndSend(.rxAnt, String(antenna))
        }
      }
      
    case .loopAButton:
      return .run { _ in
        if let panadapterId = await apiModel.activePanadapter?.id {
          await apiModel.panadapters[id: panadapterId]?.parseAndSend(.loopAEnabled)
        }
      }
      
    case .rfGainSlider(let gain):
      return .run { _ in
        if let panadapterId = await apiModel.activePanadapter?.id {
          await apiModel.panadapters[id: panadapterId]?.parseAndSend(.rfGain, String(gain))
        }
      }
    }
  }
}
