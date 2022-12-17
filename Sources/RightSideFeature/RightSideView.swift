//
//  RightSideView.swift
//  
//
//  Created by Douglas Adams on 11/13/22.
//

import SwiftUI
import ComposableArchitecture

import Objects
import CwFeature
import EqFeature
import Ph1Feature
import Ph2Feature
import TxFeature
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

public struct RightSideView: View {
  let store: StoreOf<RightSideFeature>

  public init(store: StoreOf<RightSideFeature>) {
    self.store = store
  }

  @Dependency(\.apiModel) var apiModel
  
  public var body: some View {
        
    WithViewStore(self.store) { viewStore in
      
      VStack(alignment: .center) {
        HStack {
          ControlGroup {
//            Toggle("Rx", isOn: viewStore.binding(get: \.rx, send: .rxButton ))
            Toggle("Tx", isOn: viewStore.binding(get: { $0.txState != nil }, send: .txButton ))
            Toggle("Ph1", isOn: viewStore.binding(get: { $0.ph1State != nil }, send: .ph1Button ))
            Toggle("Ph2", isOn: viewStore.binding(get: { $0.ph2State != nil }, send: .ph2Button ))
            Toggle("Cw", isOn: viewStore.binding(get: { $0.cwState != nil }, send: .cwButton ))
            Toggle("Eq", isOn: viewStore.binding(get: { $0.eqState != nil }, send: .eqButton ))
          }
//          .disabled(apiModel.activeSlice == nil)
        }
        Spacer()
        
//        Divider()
        ScrollView {
          VStack {
            IfLetStore( self.store.scope(state: \.txState, action: RightSideFeature.Action.tx),
                        then: { store in TxView(store: store) })

            IfLetStore( self.store.scope(state: \.ph1State, action: RightSideFeature.Action.ph1),
                        then: { store in Ph1View(store: store) })
            
            IfLetStore( self.store.scope(state: \.ph2State, action: RightSideFeature.Action.ph2),
                        then: { store in Ph2View(store: store) })
            
            IfLetStore( self.store.scope(state: \.cwState, action: RightSideFeature.Action.cw),
                        then: { store in CwView(store: store) })

            IfLetStore( self.store.scope(state: \.eqState, action: RightSideFeature.Action.eq),
                        then: { store in EqView(store: store) })
          }          
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct RightSideView_Previews: PreviewProvider {
  static var previews: some View {
    
    Group {
      RightSideView(
        store: Store(
          initialState: RightSideFeature.State(txState: TxFeature.State()),
          reducer: RightSideFeature()
        )
      )
      .previewDisplayName("Tx")

      RightSideView(
        store: Store(
          initialState: RightSideFeature.State(eqState: EqFeature.State(eqId: "rxsc")),
          reducer: RightSideFeature()
        )
      )
      .previewDisplayName("Eq")

      RightSideView(
        store: Store(
          initialState: RightSideFeature.State(ph1State: Ph1Feature.State()),
          reducer: RightSideFeature()
        )
      )
      .previewDisplayName("Ph1")

     RightSideView(
        store: Store(
          initialState: RightSideFeature.State(ph2State: Ph2Feature.State()),
          reducer: RightSideFeature()
        )
      )
      .previewDisplayName("Ph2")

      RightSideView(
        store: Store(
          initialState: RightSideFeature.State(cwState: CwFeature.State()),
          reducer: RightSideFeature()
        )
      )
      .previewDisplayName("CW")

      RightSideView(
        store: Store(
          initialState: RightSideFeature.State(txState: TxFeature.State(), ph1State: Ph1Feature.State(), ph2State: Ph2Feature.State(), cwState: CwFeature.State(), eqState: EqFeature.State(eqId: "rxsc")),
          reducer: RightSideFeature()
        )
      )
      .frame(height: 1200)
      .previewDisplayName("ALL")

    }
    .frame(width: 275)
  }
}
