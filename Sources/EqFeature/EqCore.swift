//
//  EqCore.swift
//  
//
//  Created by Douglas Adams on 11/13/22.
//

import Foundation
import ComposableArchitecture

import Objects
import Shared

public struct EqFeature: ReducerProtocol {
  
  public init() {}

  @Dependency(\.apiModel) var apiModel

  public struct State: Equatable {
    var eqId: String
    var eqEnabled: Bool

    public init(
      eqId: String,
      eqEnabled: Bool
    )
    {
      self.eqId = eqId
      self.eqEnabled = eqEnabled
    }
  }
  
  public enum Action: Equatable {
    case flatButton
    case onButton(Bool)
    case rxButton
    case txButton
    case levelChange(Equalizer.Property, Int)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    case .onButton(let value):
      return .run {[state] send in
        await apiModel.equalizers[id: state.eqId]!.setEqProperty(.eqEnabled, value)
      }

    case .flatButton:
      return .run {[state] send in
        await apiModel.equalizers[id: state.eqId]!.setEqProperty(.hz63, 0)
        await apiModel.equalizers[id: state.eqId]!.setEqProperty(.hz125, 0)
        await apiModel.equalizers[id: state.eqId]!.setEqProperty(.hz250, 0)
        await apiModel.equalizers[id: state.eqId]!.setEqProperty(.hz500, 0)
        await apiModel.equalizers[id: state.eqId]!.setEqProperty(.hz1000, 0)
        await apiModel.equalizers[id: state.eqId]!.setEqProperty(.hz2000, 0)
        await apiModel.equalizers[id: state.eqId]!.setEqProperty(.hz4000, 0)
        await apiModel.equalizers[id: state.eqId]!.setEqProperty(.hz8000, 0)
      }
      
    case .rxButton:
      return .none

    case .txButton:
      return .none
      
    case .levelChange(let level, let value):
      return .run {[state] send in
        await apiModel.equalizers[id: state.eqId]!.setEqProperty(level, value)
      }
    }
  }
}
