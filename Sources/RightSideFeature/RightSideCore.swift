//
//  RightSideCore.swift
//  
//
//  Created by Douglas Adams on 11/13/22.
//

import ComposableArchitecture
import Foundation

import Objects
//import CwView
import EqFeature
//import Ph1View
//import Ph2View
//import TxView

public struct RightSideFeature: ReducerProtocol {
  
  public init() {}
  
  public struct State: Equatable {
    var txEqSelected: Bool { didSet { UserDefaults.standard.set(txEqSelected, forKey: "txEqSelected") } }
    var rx: Bool
//    var txState: TxFeature.State?
//    var ph1State: Ph1Feature.State?
//    var ph2State: Ph2Feature.State?
//    var cwState: CwFeature.State?
    var eqState: EqFeature.State?
    var height: CGFloat
    
    public init(
      txEqSelected: Bool = UserDefaults.standard.bool(forKey: "txEqSelected"),
      rx: Bool = false,
//      txState: TxFeature.State? = nil,
//      ph1State: Ph1Feature.State? = nil,
//      ph2State: Ph2Feature.State? = nil,
//      cwState: CwVFeature.State? = nil,
      eqState: EqFeature.State? = nil,
      height: CGFloat = 400
    )
    {
      self.txEqSelected = txEqSelected
      self.rx = rx
//      self.txState = txState
//      self.ph1State = ph1State
//      self.ph2State = ph2State
//      self.cwState = cwState
      self.eqState = eqState
      self.height = height
    }
  }
  
  public enum Action: Equatable {
    // subview related
//    case cw(CwFeature.Action)
    case eq(EqFeature.Action)
//    case ph1(Ph1Feature.Action)
//    case ph2(Ph2Feature.Action)
//    case tx(TxFeature.Action)

    // UI controls
    case cwButton
    case eqButton
    case ph1Button
    case ph2Button
    case rxButton
    case txButton
  }
  
  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .cwButton:
//        if state.cwState == nil {
//          state.cwState = CwView.State(transmit: Transmit.shared)
//        } else {
//          state.cwState = nil
//        }
        return .none
        
      case .eqButton:
        if state.eqState == nil {
          state.eqState = EqFeature.State(eqId: state.txEqSelected ? EqType.tx.rawValue : EqType.rx.rawValue, eqEnabled: false)
        } else {
          state.eqState = nil
        }
        return .none
        
      case .ph1Button:
//        if state.ph1State == nil {
//          state.ph1State = Ph1View.State()
//        } else {
//          state.ph1State = nil
//        }
        return .none
        
      case .ph2Button:
//        if state.ph2State == nil {
//          state.ph2State = Ph2View.State(transmit: Transmit.shared)
//        } else {
//          state.ph2State = nil
//        }
        return .none

      case .rxButton:
        state.rx.toggle()
        return .none
        
      case .txButton:
//        if state.txState == nil {
//          state.txState = TxView.State(transmit: Transmit.shared)
//        } else {
//          state.txState = nil
//        }
        return .none
        
        
        // ----------------------------------------------------------------------------
        // MARK: - Actions from other features
        
//      case .cw(_):
//        return .none

//      case .eq(_):
//        return .none
      
//      case .ph2(_):
//        return .none

//      case .tx(_):
//        return .none
        
        // ----------------------------------------------------------------------------
        // MARK: - Equalizer Actions
        
      case .eq(.rxButton):
        state.txEqSelected = false
        state.eqState = EqFeature.State(eqId: state.txEqSelected ? EqType.tx.rawValue : EqType.rx.rawValue, eqEnabled: true)
        return .none
      
      case .eq(.txButton):
        state.txEqSelected = true
        state.eqState = EqFeature.State(eqId: state.txEqSelected ? EqType.tx.rawValue : EqType.rx.rawValue, eqEnabled: true)
        return .none

      case .eq(_):
        // all others ignored
        return .none
      }
    }
      // Reducers for other features
//    .ifLet(\.cwState, action: /Action.cw) {
//      CwView()
//    }
    .ifLet(\.eqState, action: /Action.eq) {
      EqFeature()
    }
//    .ifLet(\.ph1State, action: /Action.ph1) {
//      Ph1View()
//    }
//    .ifLet(\.ph2State, action: /Action.ph2) {
//      Ph2View()
//    }
//    .ifLet(\.txState, action: /Action.tx) {
//      TxView()
//    }
  }
}
