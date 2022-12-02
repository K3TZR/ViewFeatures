//
//  TxView.swift
//  
//
//  Created by Douglas Adams on 11/15/22.
//

import ComposableArchitecture
import SwiftUI

public struct TxView: View {
  let store: StoreOf<TxFeature>

  public init(store: StoreOf<TxFeature>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 10)  {
//        LevelIndicatorView(level: rfPower, type: .rfPower)
//        LevelIndicatorView(level: swr, type: .swr)
        
        Rectangle().frame(height: 30)
        Rectangle().frame(height: 30)
        
//        HStack {
//          Text("RF Power").frame(width: 80, alignment: .leading)
//          Text("\(rfPower, specifier: "%.0f")").frame(width: 25, alignment: .trailing)
//          Spacer()
//          Slider(value: $rfPower, in: 0...100).frame(width: 125)
//        }
//        HStack() {
//          Text("Tune Power").frame(width: 80, alignment: .leading)
//          Text("\(tunePower, specifier: "%.0f")").frame(width: 25, alignment: .trailing)
//          Spacer()
//          Slider(value: $tunePower, in: 0...100).frame(width: 125)
//        }
//
//        HStack(spacing: 15) {
//          Picker("", selection: $selectedTxProfile) {
//            ForEach(txProfiles, id: \.self) {
//              Text($0)
//            }
//          }
//          .labelsHidden()
//          .pickerStyle(.menu)
//          .frame(width: 80, alignment: .leading)
//          Button("Save", action: {}).font(.system(size: 10)).buttonStyle(BorderlessButtonStyle()).foregroundColor(.blue)
//          TextField("", text: $atuState).frame(width: 125)
//        }
//
//        HStack(spacing: 25) {
//          Group {
//            Toggle("TUNE", isOn: viewStore.binding(
//              get: \.transmit.tune,
//              send: .tuneButton ))
//            Toggle("MOX", isOn: viewStore.binding(
//              get: \.transmit.mox,
//              send: .moxButton ))
//            Toggle("ATU", isOn: viewStore.binding(
//              get: \.transmit.atu,
//              send: .atuButton ))
//            Toggle("MEM", isOn: viewStore.binding(
//              get: \.transmit.mem,
//              send: .memButton ))
//          }
//          .toggleStyle(.button)
//        }
        
        Divider().background(.blue)
      }
    }
    .frame(width: 260, height: 210)
    .padding(10)
  }
}

struct TxView_Previews: PreviewProvider {
    static var previews: some View {
      TxView(store: Store(initialState: TxFeature.State(), reducer: TxFeature()))
    }
}
