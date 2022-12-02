//
//  SwiftUIView.swift
//  
//
//  Created by Douglas Adams on 4/27/22.
//

import SwiftUI
import ComposableArchitecture

import Shared

// ----------------------------------------------------------------------------
// MARK: - View

public struct EqView: View {
  let store: StoreOf<EqFeature>
  
  public init(store: StoreOf<EqFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      
      VStack(alignment: .leading, spacing: 0) {
        HStack(spacing: 0) {
          Button( action: { viewStore.send(.flatButton) }) { Text("Flat") }
          Text("").frame(width: 15)
          Group {
            Text("63")
            Text("125")
            Text("250")
            Text("500")
            Text("1k")
            Text("2k")
            Text("4k")
            Text("8k")
          }.frame(width:25)
        }
        
        HStack(spacing: 0) {
          VStack(spacing: 20) {
            Text("+10 Db")
            
            Group {
              Toggle("On", isOn: viewStore.binding(
                get: \.eqEnabled ,
                send: .eqEnabledButton ))
              Toggle("Rx", isOn: viewStore.binding(
                get: { !$0.txSelected },
                send: .txButton ))
              Toggle("Tx", isOn: viewStore.binding(
                get: \.txSelected ,
                send: .txButton ))
            }.toggleStyle(.button)
            
            Text("-10 Db")
          }
          
          SliderView(store: store)
        }
        Spacer()
        Divider().background(.blue)
      }
      .frame(width: 260, height: 210)
      .padding(10)
    }
  }
}

private struct SliderView: View {
  let store: StoreOf<EqFeature>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(spacing: 5) {
        Group {
          Slider(value: viewStore.binding(get: {Double($0.hz63)}, send: {.hz63(Int($0))}), in: -10...10, step: 1)
          Slider(value: viewStore.binding(get: {Double($0.hz125)}, send: {.hz125(Int($0))}), in: -10...10, step: 1)
          Slider(value: viewStore.binding(get: {Double($0.hz250)}, send: {.hz250(Int($0))}), in: -10...10, step: 1)
          Slider(value: viewStore.binding(get: {Double($0.hz500)}, send: {.hz500(Int($0))}), in: -10...10, step: 1)
          Slider(value: viewStore.binding(get: {Double($0.hz1000)}, send: {.hz1000(Int($0))}), in: -10...10, step: 1)
          Slider(value: viewStore.binding(get: {Double($0.hz2000)}, send: {.hz2000(Int($0))}), in: -10...10, step: 1)
          Slider(value: viewStore.binding(get: {Double($0.hz4000)}, send: {.hz4000(Int($0))}), in: -10...10, step: 1)
          Slider(value: viewStore.binding(get: {Double($0.hz8000)}, send: {.hz8000(Int($0))}), in: -10...10, step: 1)
        }.frame(width: 160)
      }
      .rotationEffect(.degrees(-90), anchor: .center).offset(x: 30, y: 0)
    }
  }
}
// ----------------------------------------------------------------------------
// MARK: - Preview

struct EqView_Previews: PreviewProvider {
  static var previews: some View {
    EqView(store: Store(
      initialState: EqFeature.State(
        hz63: 5,
        hz125: -5,
        txSelected: false,
        eqEnabled: true),
      reducer: EqFeature())
    )
    .previewDisplayName("Rx Equalizer")
    
    EqView(store: Store(
      initialState: EqFeature.State(
        hz63: 5,
        hz125: -5,
        txSelected: true,
        eqEnabled: true),
      reducer: EqFeature())
    )
    .previewDisplayName("Tx Equalizer")
  }
}
