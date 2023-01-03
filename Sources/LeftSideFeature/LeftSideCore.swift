//
//  LeftSideCore.swift
//  
//
//  Created by Douglas Adams on 12/20/22.
//

import Foundation
import ComposableArchitecture

import Shared

public struct LeftSideFeature: ReducerProtocol {
  
  public init() {}
  
  public struct State: Equatable {
    var antennaPopover: Bool
    var bandPopover: Bool
    var daxPopover: Bool
    var displayPopover: Bool
    var vertical: Bool

    public init
    (
      antennaPopover: Bool = false,
      bandPopover: Bool = false,
      daxPopover: Bool = false,
      displayPopover: Bool = false,
      vertical: Bool = true
    )
    {
      self.antennaPopover = antennaPopover
      self.bandPopover = bandPopover
      self.daxPopover = daxPopover
      self.displayPopover = displayPopover
      self.vertical = vertical
    }
  }
  
  public enum Action: Equatable {
    case antennaButton
    case bandButton
    case daxButton
    case displayButton
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
      
    case .antennaButton:
      state.antennaPopover.toggle()
      return .none
      
    case .bandButton:
      state.bandPopover.toggle()
      return .none
      
    case .daxButton:
      state.daxPopover.toggle()
      return .none
      
    case .displayButton:
      state.displayPopover.toggle()
      return .none
    }
  }
}
