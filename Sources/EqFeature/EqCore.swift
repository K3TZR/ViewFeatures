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
    public init(eqId: String) {self.eqId = eqId}
  }
  
  public enum Action: Equatable {
    case flatButton
    case onButton
    case rxButton
    case txButton
    case levelChange(Equalizer.Property, Int)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {

    case .onButton:
      return .run {[id = state.eqId] send in
        await apiModel.equalizerEnable(id)
      }

    case .flatButton:
      return .run {[id = state.eqId] send in
        await apiModel.equalizerFlat(id)
      }
      
    case .rxButton, .txButton:
      // action taken in parent feature
      return .none

    case .levelChange(let level, let value):
      return .run {[id = state.eqId] send in
        await apiModel.equalizerLevel(id, level, value)
      }
    }
  }
}
