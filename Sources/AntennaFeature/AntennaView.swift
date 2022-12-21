//
//  AntennaView.swift
//  
//
//  Created by Douglas Adams on 12/21/22.
//

import ComposableArchitecture
import SwiftUI

import Objects

public struct AntennaView: View {
  let store: StoreOf<AntennaFeature>
  @ObservedObject var apiModel: ApiModel
  
  public init(store: StoreOf<AntennaFeature>, apiModel: ApiModel) {
    self.store = store
    self.apiModel = apiModel
  }
  
  public var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading) {
        
        let panadapter = apiModel.panadapters[id: viewStore.panadapterId] ?? Panadapter("0x99999999".streamId!)
        
        Antenna(viewStore: viewStore, panadapter: panadapter)
        Loop(viewStore: viewStore, panadapter: panadapter)
        RfGain(viewStore: viewStore, panadapter: panadapter)
      }
      .frame(width: 160)
      .padding(5)
    }
  }
}

private struct Antenna: View {
  let viewStore: ViewStore<AntennaFeature.State, AntennaFeature.Action>
  @ObservedObject var panadapter: Panadapter

  var body: some View {
    HStack(spacing: 45) {
      Text("RxAnt")
      Picker("RxAnt", selection: viewStore.binding(
        get: {_ in  panadapter.rxAnt },
        send: { .antSelectionPicker($0) })) {
          ForEach(panadapter.antList, id: \.self) {
            Text($0)
          }
        }
        .labelsHidden()
        .pickerStyle(.menu)
        .frame(width: 70, alignment: .leading)
    }
  }
}

private struct Loop: View {
  let viewStore: ViewStore<AntennaFeature.State, AntennaFeature.Action>
  @ObservedObject var panadapter: Panadapter

  var body: some View {
    Button(action: {}) { Text("LoopA") }
    }
}

private struct RfGain: View {
  let viewStore: ViewStore<AntennaFeature.State, AntennaFeature.Action>
  @ObservedObject var panadapter: Panadapter

  var body: some View {
    HStack {
      Text("Rf Gain")
      Text("\(panadapter.rfGain)").frame(width: 25, alignment: .trailing)
      Slider(value: viewStore.binding(get: {_ in Double(panadapter.rfGain) }, send: { .rfGainSlider( Int($0)) }), in: -10...40, step: 10)
    }
  }
}

struct AntennaView_Previews: PreviewProvider {
    static var previews: some View {
      AntennaView(store: Store(initialState: AntennaFeature.State(panadapterId: "0x99999999".streamId!), reducer: AntennaFeature()), apiModel: ApiModel())
        .frame(width: 160)
        .padding(5)
    }
}
