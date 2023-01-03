//
//  DaxCore.swift
//  
//
//  Created by Douglas Adams on 12/21/22.
//

import ComposableArchitecture
import Foundation

import Shared

public struct DaxFeature: ReducerProtocol {
  
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
    case daxIqChannelPicker(Int)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    
    case .daxIqChannelPicker(let channel):
      return .run { _ in
        if let panadapterId = await apiModel.activePanadapter?.id {
          await apiModel.panadapters[id: panadapterId]?.parseAndSend(.daxIqChannel, String(channel))
        }
      }
    }
  }
}
