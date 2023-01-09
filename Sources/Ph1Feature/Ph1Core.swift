//
//  Ph1Core.swift
//
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import Objects
import Shared

public struct Ph1Feature: ReducerProtocol {
  public init() {}
  
  @Dependency(\.apiModel) var apiModel
  
  public struct State: Equatable {
    public init() {}
  }
  
  public enum UpdateType{
    case set
    case send
    case setAndSend
  }
  
  public enum Action: Equatable {
    case profileProperty(String, String)
    case transmitProperty(UpdateType, Transmit.Property, String)
  }

  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {

    case .transmitProperty(let type, let property, let value):
      return .run { _ in
        switch type {
        case .set:        await apiModel.transmit.set(property, value)
        case .send:       await apiModel.transmit.send(property)
        case .setAndSend: await apiModel.transmit.setAndSend(property, value)
        }
      }

    case .profileProperty(let type, let name):
      guard type == "mic" || type == "tx" || type == "global" else { return .none }
      return .run { _ in
        await apiModel.profileLoad(type, name)
      }
    }
  }
}
