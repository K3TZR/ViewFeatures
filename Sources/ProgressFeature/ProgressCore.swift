//
//  ProgressCore.swift
//  ViewComponents/ProgressView
//
//  Created by Douglas Adams on 3/23/22.
//

import Foundation
import ComposableArchitecture
import Combine

public struct ProgressFeature: ReducerProtocol {
  
  public init() {}

  struct TimerId: Hashable {}

  public struct State: Equatable {
    var heading: String
    var message: String?
    var duration: Float?
    var value: Float

    public init
    (
      heading: String = "Please Wait",
      message: String? = nil,
      duration: Float? = nil,
      value: Float = 0
    )
    {
      self.heading = heading
      self.message = message
      self.duration = duration
      self.value = value
    }
  }
  
  public enum Action: Equatable {
    case cancel
    case completed
    case startTimer
    case timerTicked
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
      
    case .cancel:
      return .cancel(id: TimerId())
      
    case .completed:
      return .cancel(id: TimerId())
      
    case .startTimer:
      return Effect.timer(id: TimerId(), every: 0.1, on: DispatchQueue.main)
        .receive(on: DispatchQueue.main)
        .catchToEffect()
        .map { _ in .timerTicked }
      
    case .timerTicked:
      state.value += (0.1/state.duration!)
      if state.value >= 1.0 { return Effect(value: .completed) }
      return .none
    }
  }
}


//public struct ProgressState: Equatable {
//  var heading: String
//  var message: String?
//  var duration: Float?
//  var value: Float
//
//  public init
//  (
//    heading: String = "Please Wait",
//    message: String? = nil,
//    duration: Float? = nil,
//    value: Float = 0
//  )
//  {
//    self.heading = heading
//    self.message = message
//    self.duration = duration
//    self.value = value
//  }
//}
//
//public enum ProgressAction: Equatable {
//  case cancel
//  case completed
//  case startTimer
//  case timerTicked
//}
//
//public struct ProgressEnvironment {
//  public init() {}
//}
//
//public let progressReducer = Reducer<ProgressState, ProgressAction, ProgressEnvironment> { state, action, _ in
//  struct TimerId: Hashable {}
//
//  switch action {
//
//  case .cancel:
//    return .cancel(id: TimerId())
//
//  case .completed:
//    return .cancel(id: TimerId())
//
//  case .startTimer:
//    return Effect.timer(id: TimerId(), every: 0.1, on: DispatchQueue.main)
//      .receive(on: DispatchQueue.main)
//      .catchToEffect()
//      .map { _ in .timerTicked }
//
//  case .timerTicked:
//    state.value += (0.1/state.duration!)
//    if state.value >= 1.0 { return Effect(value: .completed) }
//    return .none
//  }
//}
////  .debug("-----> PROGRESSVIEW")
