//
//  TxCore.swift
//  
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import ApiModel
import Shared

public struct TxFeature: ReducerProtocol {

  public init() {}
  
  public struct State: Equatable {
    var transmit: Transmit

    public init(
      transmit: Transmit
    )
    {
      self.transmit = transmit
    }
  }
  
  public enum Action: Equatable {
    case atuButton
    case memButton
    case moxButton
    case tuneButton
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    case .atuButton:
      print("atuButton")
      return .none

    case .memButton:
      print("memButton")
      return .none

    case .moxButton:
      print("moxButton")
      return .none

    case .tuneButton:
      print("tuneButton")
      return .none
    }
  }
}
