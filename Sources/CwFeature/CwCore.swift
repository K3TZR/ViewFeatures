//
//  CwCore.swift
//  
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import Shared

public struct CwFeature: ReducerProtocol {
  public init() {}
  
  @Dependency(\.apiModel) var apiModel

  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case breakinButton
    case delayLevel(Int)
    case iambicButton
    case pitchChange(Int)
    case sidetoneButton
    case sidetoneGain(Int)
    case sidetonePan(Int)
    case speedLevel(Int)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {

    case .breakinButton:
      return .run { _ in
        await apiModel.transmit.parseAndSend(.cwBreakInEnabled)
      }

    case .delayLevel(let value):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.cwBreakInDelay, String(value))
      }

    case .iambicButton:
      return .run { _ in
        await apiModel.transmit.parseAndSend(.cwIambicEnabled)
      }

    case .pitchChange(let value):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.cwPitch, String(value))
      }

    case .sidetoneButton:
      return .run { _ in
        await apiModel.transmit.parseAndSend(.cwSidetoneEnabled)
      }

    case .sidetoneGain(let value):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.cwMonitorGain, String(value))
      }

    case .sidetonePan(let value):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.cwMonitorPan, String(value))
      }

    case .speedLevel(let value):
      return .run { _ in
        await apiModel.transmit.parseAndSend(.cwSpeed, String(value))
      }
    }
  }
}
