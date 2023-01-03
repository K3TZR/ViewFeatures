//
//  GpsSettingsCore.swift
//  
//
//  Created by Douglas Adams on 12/31/22.
//

import Foundation
import ComposableArchitecture

import Objects
import Shared

public struct GpsSettingsFeature: ReducerProtocol {
  
  public init() {}
  
  @Dependency(\.apiModel) var apiModel
  
  public struct State: Equatable {
    public init
    (
    )
    {
    }
  }
  
  public enum Action: Equatable {
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
//    switch action {
//    
//    }
  }
}
