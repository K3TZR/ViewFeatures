//
//  EqCore.swift
//  
//
//  Created by Douglas Adams on 11/13/22.
//

import Foundation
import ComposableArchitecture

import Shared

public struct EqFeature: ReducerProtocol, Equatable {

  public init() {}
  
  public struct State: Equatable {
    var hz63: Int
    var hz125: Int
    var hz250: Int
    var hz500: Int
    var hz1000: Int
    var hz2000: Int
    var hz4000: Int
    var hz8000: Int
    var txSelected: Bool
    var eqEnabled: Bool

    public init(
      hz63: Int = 0,
      hz125: Int = 0,
      hz250: Int = 0,
      hz500: Int = 0,
      hz1000: Int = 0,
      hz2000: Int = 0,
      hz4000: Int = 0,
      hz8000: Int = 0,
      txSelected: Bool = false,
      eqEnabled: Bool = false
    )
    {
      self.hz63 = hz63
      self.hz125 = hz125
      self.hz250 = hz250
      self.hz500 = hz500
      self.hz1000 = hz1000
      self.hz2000 = hz2000
      self.hz4000 = hz4000
      self.hz8000 = hz8000
      self.txSelected = txSelected
      self.eqEnabled = eqEnabled
    }
  }
  
  public enum Action: Equatable {
    case eqEnabledButton
    case flatButton
    case txButton
    case hz63(Int)
    case hz125(Int)
    case hz250(Int)
    case hz500(Int)
    case hz1000(Int)
    case hz2000(Int)
    case hz4000(Int)
    case hz8000(Int)


  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    case .eqEnabledButton:
      state.eqEnabled.toggle()
      return .none
      
    case .flatButton:
      state.hz63 = 0
      state.hz125 = 0
      state.hz250 = 0
      state.hz500 = 0
      state.hz1000 = 0
      state.hz2000 = 0
      state.hz4000 = 0
      state.hz8000 = 0
      return .none

    case .hz63(let value):
      state.hz63 = value
      return .none
    case .hz125(let value):
      state.hz125 = value
      return .none
    case .hz250(let value):
      state.hz250 = value
      return .none
    case .hz500(let value):
      state.hz500 = value
      return .none
    case .hz1000(let value):
      state.hz1000 = value
      return .none
    case .hz2000(let value):
      state.hz2000 = value
      return .none
    case .hz4000(let value):
      state.hz4000 = value
      return .none
    case .hz8000(let value):
      state.hz8000 = value
      return .none

    default:
      return .none
    }
  }
}
