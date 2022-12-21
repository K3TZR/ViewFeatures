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
    var panadapterId: StreamId

    public init
    (
      panadapterId: StreamId,
      antennaPopover: Bool = false,
      bandPopover: Bool = false,
      daxPopover: Bool = false,
      displayPopover: Bool = false
    )
    {
      self.panadapterId = panadapterId
      self.antennaPopover = antennaPopover
      self.bandPopover = bandPopover
      self.daxPopover = daxPopover
      self.displayPopover = displayPopover
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
      print("antennaButton")
      return .none
      
    case .bandButton:
      state.bandPopover.toggle()
      print("bandButton")
      return .none
      
    case .daxButton:
      state.daxPopover.toggle()
      print("daxButton")
      return .none
      
    case .displayButton:
      state.displayPopover.toggle()
      print("displayButton")
      return .none
    }
  }
}
