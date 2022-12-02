//
//  RightSideView.swift
//  
//
//  Created by Douglas Adams on 11/13/22.
//

import SwiftUI
import ComposableArchitecture

import Objects
//import CwFeature
import EqFeature
//import Ph1Feature
//import Ph2Feature
//import TxFeature
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

public struct RightSideView: View {
  let store: StoreOf<RightSideFeature>
  @ObservedObject var apiModel: ApiModel

  public init(store: StoreOf<RightSideFeature>, apiModel: ApiModel) {
    self.store = store
    self.apiModel = apiModel
  }

  public var body: some View {
        
    WithViewStore(self.store) { viewStore in
      
      VStack(alignment: .center) {
        HStack {
          ControlGroup {
//            Toggle("Rx", isOn: viewStore.binding(get: \.rx, send: .rxButton ))
//            Toggle("Tx", isOn: viewStore.binding(get: { $0.txState != nil }, send: .txButton ))
//            Toggle("Ph1", isOn: viewStore.binding(get: { $0.ph1State != nil }, send: .ph1Button ))
//            Toggle("Ph2", isOn: viewStore.binding(get: { $0.ph2State != nil }, send: .ph2Button ))
//            Toggle("Cw", isOn: viewStore.binding(get: { $0.cwState != nil }, send: .cwButton ))
            Toggle("Eq", isOn: viewStore.binding(get: { $0.eqState != nil }, send: .eqButton ))
          }
//          .disabled(viewStore.model.activeSlice == nil)
        }
        Spacer()
        
        Divider()
        ScrollView {
          VStack {
//            IfLetStore( self.store.scope(state: \.txState, action: RightSideFeature.Action.tx),
//                        then: { store in TxView(store: store) })

//            IfLetStore( self.store.scope(state: \.ph1State, action: RightSideFeature.Action.ph1),
//                        then: { store in Ph1View(store: store) })
            
//            IfLetStore( self.store.scope(state: \.ph2State, action: RightSideFeature.Action.ph2),
//                        then: { store in Ph2View(store: store, transmit: Transmit.shared) })
            
//            IfLetStore( self.store.scope(state: \.cwState, action: RightSideFeature.Action.cw),
//                        then: { store in CwView(store: store, transmit: Transmit.shared, alcMeter: apiModel.findMeter(.voltageHwAlc)!) })

            IfLetStore( self.store.scope(state: \.eqState, action: RightSideFeature.Action.eq),
                        then: { store in EqView(store: store) })
          }          
        }.frame(minWidth: 275, minHeight: viewStore.height)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct RightSideView_Previews: PreviewProvider {
  static var previews: some View {
    RightSideView(
      store: Store(
        initialState: RightSideFeature.State(),
        reducer: RightSideFeature()
      ),
      apiModel: ApiModel.shared
    )
  }
}

//
//    RightSideView(
//      store: Store(
//        initialState: RightSideState(),
//        reducer: rightSideReducer,
//        environment: RightSideEnvironment()
//      )
//    )
//
//    RightSideView(
//      store: Store(
//        initialState: RightSideState(),
//        reducer: rightSideReducer,
//        environment: RightSideEnvironment()
//      )
//    )
//
//    RightSideView(
//      store: Store(
//        initialState: RightSideState(),
//        reducer: rightSideReducer,
//        environment: RightSideEnvironment()
//      )
//    )
//
//    RightSideView(
//      store: Store(
//        initialState: RightSideState(),
//        reducer: rightSideReducer,
//        environment: RightSideEnvironment()
//      )
//    )
//
//    RightSideView(
//      store: Store(
//        initialState: RightSideState(),
//        reducer: rightSideReducer,
//        environment: RightSideEnvironment()
//      )
//    )
//
//    RightSideView(
//      store: Store(
//        initialState: RightSideState(),
//        reducer: rightSideReducer,
//        environment: RightSideEnvironment()
//      )
//    )
//
//    RightSideView(
//      store: Store(
//        initialState: RightSideState(),
//        reducer: rightSideReducer,
//        environment: RightSideEnvironment()
//      )
//    )
//  }
//}
