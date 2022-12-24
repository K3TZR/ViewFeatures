//
//  SwiftUIView.swift
//  
//
//  Created by Douglas Adams on 4/27/22.
//

import SwiftUI
import ComposableArchitecture

import Objects
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

public struct EqView: View {
  let store: StoreOf<EqFeature>
  
  @Dependency(\.apiModel) var apiModel

  public init(store: StoreOf<EqFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      
      VStack(alignment: .leading, spacing: 10) {
        HeadingView(viewStore: viewStore)
        HStack(spacing: 20) {
          ButtonView(viewStore: viewStore, equalizer: apiModel.equalizers[id: viewStore.eqId] ?? Equalizer("dummy"))
          SliderView(viewStore: viewStore, equalizer: apiModel.equalizers[id: viewStore.eqId] ?? Equalizer("dummy"))
        }
        Divider().background(.blue)
      }
    }
  }
}

private struct HeadingView: View {
  let viewStore: ViewStore<EqFeature.State, EqFeature.Action>

  var body: some View {

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
  }
}

private struct ButtonView: View {
  let viewStore: ViewStore<EqFeature.State, EqFeature.Action>
  @ObservedObject var equalizer: Equalizer
  
  var body: some View {

    VStack(alignment: .center, spacing: 25) {
      Text("+10 Db")
      Group {
        Toggle("On", isOn: viewStore.binding(
          get: {_ in equalizer.eqEnabled } ,
          send: .onButton ))
        Toggle("Rx", isOn: viewStore.binding(
          get: {_ in viewStore.eqId == EqType.rx.rawValue },
          send: .rxButton ))
        Toggle("Tx", isOn: viewStore.binding(
          get: {_ in viewStore.eqId == EqType.tx.rawValue },
          send: .txButton ))
      }.toggleStyle(.button)
      Text("-10 Db")
    }
  }
}

private struct SliderView: View {
  let viewStore: ViewStore<EqFeature.State, EqFeature.Action>
  @ObservedObject var equalizer: Equalizer
  
  var body: some View {
    
    VStack(alignment: .center, spacing: 5) {
      Group {
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz63)}, send: { .levelChange(.hz63, Int($0)) }), in: -10...10)
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz125)}, send: { .levelChange(.hz125, Int($0)) }), in: -10...10)
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz250)}, send: { .levelChange(.hz250, Int($0)) }), in: -10...10)
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz500)}, send: { .levelChange(.hz500, Int($0)) }), in: -10...10)
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz1000)}, send: { .levelChange(.hz1000, Int($0)) }), in: -10...10)
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz2000)}, send: { .levelChange(.hz2000, Int($0)) }), in: -10...10)
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz4000)}, send: { .levelChange(.hz4000, Int($0)) }), in: -10...10)
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz8000)}, send: { .levelChange(.hz8000, Int($0)) }), in: -10...10)
      }
      .frame(width: 180)
    }
    .rotationEffect(.degrees(-90), anchor: .center)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct EqView_Previews: PreviewProvider {
  
  static var previews: some View {

    Group {
      EqView(store: Store(initialState: EqFeature.State(eqId: EqType.rx.rawValue),
                          reducer: EqFeature()))
      .frame(width: 275, height: 250)
      .previewDisplayName("Rx Equalizer")
      
      
      EqView(store: Store(initialState: EqFeature.State(eqId: EqType.tx.rawValue),
                          reducer: EqFeature()))
      .frame(width: 275, height: 250)
      .previewDisplayName("Tx Equalizer")
    }
  }
}
