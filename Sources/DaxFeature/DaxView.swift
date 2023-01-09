//
//  DaxView.swift
//  
//
//  Created by Douglas Adams on 12/21/22.
//

import ComposableArchitecture
import SwiftUI

import Objects

public struct DaxView: View {
  let store: StoreOf<DaxFeature>
  @ObservedObject var apiModel: ApiModel
  
  public init(store: StoreOf<DaxFeature>, apiModel: ApiModel) {
    self.store = store
    self.apiModel = apiModel
  }
  
  public var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading) {
        
        let panadapter = apiModel.panadapters[id: apiModel.activePanadapter?.id ?? "0x99999999".streamId!] ?? Panadapter("0x99999999".streamId!)
        
        Dax(viewStore: viewStore, panadapter: panadapter)
      }
      .frame(width: 160)
      .padding(5)
    }
  }
}

private struct Dax: View {
  let viewStore: ViewStore<DaxFeature.State, DaxFeature.Action>
  @ObservedObject var panadapter: Panadapter
  
  var body: some View {
    HStack(spacing: 5) {
      Text("Dax IQ Channel")
      Picker("", selection: viewStore.binding(
        get: {_ in  panadapter.daxIqChannel },
        send: { .panadapterProperty(.daxIqChannel, String($0)) })) {
          ForEach(panadapter.daxIqChoices, id: \.self) {
            Text(String($0)).tag($0)
          }
        }
        .labelsHidden()
        .pickerStyle(.menu)
        .frame(width: 50, alignment: .leading)
    }
  }
}

struct DaxView_Previews: PreviewProvider {
    static var previews: some View {
      DaxView(store: Store(initialState: DaxFeature.State(), reducer: DaxFeature()), apiModel: ApiModel())
        .frame(width: 160)
        .padding(5)
    }
}
