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
            Toggle("Rx", isOn: viewStore.binding(get: { $0.rxState != nil }, send: .rxButton ))
            Toggle("Tx", isOn: viewStore.binding(get: { $0.txState != nil }, send: .txButton ))
            Toggle("Ph1", isOn: viewStore.binding(get: { $0.ph1State != nil }, send: .ph1Button ))
            Toggle("Ph2", isOn: viewStore.binding(get: { $0.ph2State != nil }, send: .ph2Button ))
            Toggle("Cw", isOn: viewStore.binding(get: { $0.cwState != nil }, send: .cwButton ))
            Toggle("Eq", isOn: viewStore.binding(get: { $0.eqState != nil }, send: .eqButton ))
          }
          .frame(width: 280)
          .disabled(apiModel.clientInitialized == false)
        }
        Spacer()
        
        ScrollView {
          if apiModel.clientInitialized {
            VStack {
              //            IfLetStore( self.store.scope(state: \.rxState, action: RightSideFeature.Action.rx),
              //                        then: { store in RxView(store: store) })
              
              IfLetStore( self.store.scope(state: \.txState, action: RightSideFeature.Action.tx),
                          then: { store in TxView(store: store) })
              
              IfLetStore( self.store.scope(state: \.ph1State, action: RightSideFeature.Action.ph1),
                          then: { store in Ph1View(store: store, apiModel: apiModel) })
              
              IfLetStore( self.store.scope(state: \.ph2State, action: RightSideFeature.Action.ph2),
                          then: { store in Ph2View(store: store) })
              
              IfLetStore( self.store.scope(state: \.cwState, action: RightSideFeature.Action.cw),
                          then: { store in CwView(store: store) })
              
              IfLetStore( self.store.scope(state: \.eqState, action: RightSideFeature.Action.eq),
                          then: { store in EqView(store: store) })
            }
            .padding(.horizontal, 10)
            
          } else {
            EmptyView()
          }
        }
      }
      .onChange(of: apiModel.clientInitialized) {
        viewStore.send(.openClose($0))
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct RightSideView_Previews: PreviewProvider {
  static var previews: some View {
    
    Group {
      //      RightSideView(
      //        store: Store(
      //          initialState: RightSideFeature.State(txState: RxFeature.State()),
      //          reducer: RightSideFeature()
      //        ), apiModel: ApiModel()
      //      )
      //      .previewDisplayName("Rx")
      
      RightSideView(
        store: Store(
          initialState: RightSideFeature.State(txButton: true),
          reducer: RightSideFeature()
        ), apiModel: ApiModel()
      )
      .previewDisplayName("Tx")
      
      RightSideView(
        store: Store(
          initialState: RightSideFeature.State(eqButton: true, txEqSelected: false),
          reducer: RightSideFeature()
        ), apiModel: ApiModel()
      )
      .previewDisplayName("Eq")
      
      RightSideView(
        store: Store(
          initialState: RightSideFeature.State(ph1Button: true),
          reducer: RightSideFeature()
        ), apiModel: ApiModel()
      )
      .previewDisplayName("Ph1")
      
      RightSideView(
        store: Store(
          initialState: RightSideFeature.State(ph2Button: true),
          reducer: RightSideFeature()
        ), apiModel: ApiModel()
      )
      .previewDisplayName("Ph2")
      
      RightSideView(
        store: Store(
          initialState: RightSideFeature.State(cwButton: true),
          reducer: RightSideFeature()
        ), apiModel: ApiModel()
      )
      .previewDisplayName("CW")
      
      RightSideView(
        store: Store(
          initialState: RightSideFeature.State(cwButton: true, eqButton: true, ph1Button: true, ph2Button: true, rxButton: true, txButton: true, txEqSelected: false),
          reducer: RightSideFeature()
        ), apiModel: ApiModel()
      )
      .frame(height: 1200)
      .previewDisplayName("ALL")
      
    }
    .frame(width: 275)
  }
}
