//
//  TxCore.swift
//
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import Objects
import Shared

public struct TxFeature: ReducerProtocol {
  public init() {}
  
  @Dependency(\.apiModel) var apiModel
  
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case moxButton(Bool)
    case setAtuBool(Atu.Property, Bool)
    case setTransmitBool(Transmit.Property, Bool)
    case setTransmitInt(Transmit.Property, Int)
    case txProfile(String)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {    
    switch action {
      
    case .moxButton(let state):
      return .run { _ in
        await apiModel.transmit.sendMox(state)
      }
      
    case .setAtuBool(let property, let value):
      return .run { _ in
        await apiModel.atu.setAndSend(property, value.as1or0)
      }

    case .setTransmitBool(let property, let value):
      return .run { _ in
        await apiModel.transmit.setAndSend(property, value.as1or0)
      }
      
    case .setTransmitInt(let property, let value):
      return .run { _ in
        await apiModel.transmit.setAndSend(property, String(value))
      }
      
    case .txProfile(let name):
      return .run { _ in
        await apiModel.profileLoad("tx", name)
      }
    }
  }
}
