//
//  DisplayCore.swift
//  
//
//  Created by Douglas Adams on 12/21/22.
//

import Foundation
import ComposableArchitecture

import Objects
import Shared

public struct DisplayFeature: ReducerProtocol {
  public init() {}
  
  @Dependency(\.apiModel) var apiModel
  
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case panadapterProperty(Panadapter.Property, String)
    case waterfallProperty(Waterfall.Property, String)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
      
    case .panadapterProperty(let property, let value):
      return .run { _ in
          await apiModel.panadapterProperty(property, value)
      }

    case .waterfallProperty(let property, let value):
      return .run { _ in
          await apiModel.waterfallProperty(property, value)
      }
    }
  }
}
