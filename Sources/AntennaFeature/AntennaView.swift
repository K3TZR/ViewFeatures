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
        
        let panadapter = apiModel.panadapters[id: apiModel.activePanadapter?.id ?? "0x99999999".streamId!] ?? Panadapter("0x99999999".streamId!)
        
        Antenna(viewStore: viewStore, panadapter: panadapter)
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
        send: { .panadapterProperty(.rxAnt, $0) })) {
          ForEach(panadapter.antList, id: \.self) {
            Text($0).tag($0)
          }
        }
        .labelsHidden()
        .pickerStyle(.menu)
        .frame(width: 70, alignment: .leading)
    }
      Toggle("Loop A", isOn: viewStore.binding(
        get: {_ in panadapter.loopAEnabled },
        send: { .panadapterProperty(.loopAEnabled, $0.as1or0 ) } ))
      .toggleStyle(.button)

    HStack {
      Text("Rf Gain")
      Text("\(panadapter.rfGain)").frame(width: 25, alignment: .trailing)
      Slider(value: viewStore.binding(get: {_ in Double(panadapter.rfGain) }, send: { .panadapterProperty(.rfGain, String(Int($0))) }), in: -10...20, step: 10)
    }
  }
}

struct AntennaView_Previews: PreviewProvider {
    static var previews: some View {
      AntennaView(store: Store(initialState: AntennaFeature.State(), reducer: AntennaFeature()), apiModel: ApiModel())
        .frame(width: 160)
        .padding(5)
    }
}
