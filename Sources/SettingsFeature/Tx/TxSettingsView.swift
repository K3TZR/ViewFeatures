//
//  TxSettingsView.swift
//  xMini6001
//
//  Created by Douglas Adams on 5/13/21.
//

import ComposableArchitecture
import SwiftUI

import Objects
import Shared

struct TxSettingsView: View {
  let store: StoreOf<TxSettingsFeature>
  @Dependency(\.apiModel) var apiModel
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      if apiModel.radio == nil {
        VStack {
          Text("Radio must be connected").font(.title).foregroundColor(.red)
          Text("to use Tx Settings").font(.title).foregroundColor(.red)
        }

      } else {
        VStack {
          Group {
            InterlocksGridView(viewStore: viewStore,interlock: apiModel.interlock)
            Spacer()
            Divider().foregroundColor(.blue)
          }
          Group {
            Spacer()
            TxGridView(viewStore: viewStore,
                       interlock: apiModel.interlock,
                       txProfile: apiModel.profiles[id: "tx"] ?? Profile("tx"),
                       transmit: apiModel.transmit
            )
            Spacer()
          }
        }
      }
    }
  }
}

private struct InterlocksGridView: View {
  let viewStore: ViewStore<TxSettingsFeature.State, TxSettingsFeature.Action>
  @ObservedObject var interlock: Interlock
  
  private let interlockLevels = ["Disabled", "Active High", "Active Low"]
  
  let width: CGFloat = 100
  var rcaSelection: Int {
    guard interlock.rcaTxReqEnabled else { return 0 }
    return interlock.rcaTxReqPolarity ? 1 : 2
  }
  var accSelection: Int {
    guard interlock.accTxReqEnabled else { return 0 }
    return interlock.accTxReqPolarity ? 1 : 2
  }
  
  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 200, verticalSpacing: 20) {
      
      GridRow() {
        Picker("RCA", selection: viewStore.binding(
          get: {_ in interlockLevels[rcaSelection] },
          send: { .rcaInterlock($0) } )) {
            ForEach(interlockLevels, id: \.self) {
              Text($0).tag($0)
            }
          }
          .pickerStyle(.menu)
          .frame(width: 180)
        
        Picker("ACC", selection: viewStore.binding(
          get: {_ in interlockLevels[accSelection]  },
          send: { .accInterlock($0) } )) {
            ForEach(interlockLevels, id: \.self) {
              Text($0).tag($0)
            }
          }
          .pickerStyle(.menu)
          .frame(width: 180)
        
      }
      GridRow() {
        HStack {
          Toggle("RCA TX1", isOn: viewStore.binding(
            get: {_ in  interlock.tx1Enabled },
            send: .rcaTx1Button ))
          TextField("tx1 delay", value: viewStore.binding(
            get: {_ in  interlock.tx1Delay},
            send: { .rcaTx1Delay($0) } ), format: .number)
        }
        HStack {
          Toggle("ACC TX", isOn: viewStore.binding(
            get: {_ in  interlock.accTxEnabled },
            send: .accTxButton ))
          TextField("acc delay", value: viewStore.binding(
            get: {_ in  interlock.accTxDelay},
            send: { .accTxDelay($0) } ), format: .number)
        }
      }.frame(width: 180)
      
      GridRow() {
        HStack {
          Toggle("RCA TX2", isOn: viewStore.binding(
            get: {_ in  interlock.tx2Enabled},
            send: .rcaTx2Button ))
          TextField("tx2 delay", value: viewStore.binding(
            get: {_ in  interlock.tx2Delay },
            send: { .rcaTx2Delay($0) } ), format: .number)
        }
        HStack {
          Text("TX Delay").frame(width: 65, alignment: .leading)
          TextField("tx delay", value: viewStore.binding(
            get: {_ in  interlock.txDelay},
            send: { .txDelay($0) } ), format: .number)
        }
      }.frame(width: 180)
      
      GridRow() {
        HStack {
          Toggle("RCA TX3", isOn: viewStore.binding(
            get: {_ in  interlock.tx3Enabled},
            send: .rcaTx3Button ))
          TextField("tx3 delay", value: viewStore.binding(
            get: {_ in  interlock.tx3Delay },
            send: { .rcaTx3Delay($0) } ), format: .number)
        }
        HStack {
          Text("Timeout (min)")
          TextField("minutes", value: viewStore.binding(
            get: {_ in  interlock.timeout },
            send: { .timeout($0) } ), format: .number)
        }
      }.frame(width: 180)
    }
  }
}

private struct TxGridView: View {
  let viewStore: ViewStore<TxSettingsFeature.State, TxSettingsFeature.Action>
  @ObservedObject var interlock: Interlock
  @ObservedObject var txProfile: Profile
  @ObservedObject var transmit: Transmit
  
  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 20) {
      
      GridRow() {
        Toggle("TX Inhibit", isOn: viewStore.binding(
          get: {_ in  interlock.txAllowed },
          send: .txInhibitButton ))
        .toggleStyle(.checkbox)
        Toggle("TX in Waterfall", isOn: viewStore.binding(
          get: {_ in  transmit.txInWaterfallEnabled},
          send: .txInWaterfallButton ))
        .toggleStyle(.checkbox)
        Text("Tx Profile")
        Picker("", selection: viewStore.binding(
          get: {_ in  txProfile.current.id },
          send: { .txProfile($0) })) {
            ForEach(txProfile.list) {
              Text($0.name).tag($0.id)
            }
          }
          .labelsHidden()
          .pickerStyle(.menu)
          .frame(width: 180)
      }
      GridRow() {
        Text("Max Power")
        HStack {
          Text("\(String(format: "%.0f", transmit.maxPowerLevel))")
          Slider(value: viewStore.binding(
            get: {_ in  Double(transmit.maxPowerLevel) },
            send: { .maxPowerLevel(Int($0)) } ), in: 0...100).frame(width: 130)
        }
        Toggle("Hardware ALC", isOn: viewStore.binding(
          get: {_ in  transmit.hwAlcEnabled},
          send: .hardwareAlcButton ))
      }
    }
  }
}

struct TxSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    TxSettingsView(store: Store(initialState: TxSettingsFeature.State(), reducer: TxSettingsFeature()))
      .frame(width: 600, height: 350)
      .padding()
  }
}
