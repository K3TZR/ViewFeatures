//
//  PickerFeature.swift
//
//  Created by Douglas Adams on 11/13/21.
//

import Foundation
import ComposableArchitecture

import Shared

public struct PickerFeature: ReducerProtocol {

  public init() {}
  
  public struct State: Equatable {
    var pickables: IdentifiedArrayOf<Pickable>
    public var defaultValue: DefaultValue?
    var isGui: Bool
    var selection: (Pickable)?
    public var testResult: Bool

    public init(
      pickables: IdentifiedArrayOf<Pickable>,
      defaultValue: DefaultValue? = nil,
      isGui: Bool = true,
      selection: Pickable? = nil,
      testResult: Bool = false
    )
    {
      self.pickables = pickables
      self.defaultValue = defaultValue
      self.isGui = isGui
      self.selection = selection
      self.testResult = testResult
    }
  }
  
  public enum Action: Equatable {
    case cancelButton
    case connectButton(Pickable)
    case defaultButton(Pickable)
    case selectionAction(Pickable)
    case testButton(Pickable)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
    case .selectionAction(let selection):
      if state.selection == selection {
        state.selection = nil
      } else {
        state.selection = selection
      }
      return .none

    default:
      return .none
    }
  }
}
