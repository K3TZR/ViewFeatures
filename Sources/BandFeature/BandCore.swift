//
//  BandCore.swift
//  
//
//  Created by Douglas Adams on 12/20/22.
//

import Foundation
import ComposableArchitecture

import Objects
import Shared

public struct BandFeature: ReducerProtocol {
  public init() {}
  
  public struct State: Equatable {
    public init() {}
  }
  
  @Dependency(\.apiModel) var apiModel

  public enum Action: Equatable {
    case panadapterProperty(Panadapter.Property, String)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
      
    case .panadapterProperty(let property, let value):
      return .run { _ in
        await apiModel.panadapterProperty(property, value)
      }
    }
  }
}
