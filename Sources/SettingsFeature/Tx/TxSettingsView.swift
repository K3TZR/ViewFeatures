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
      if apiModel.clientInitialized {
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
      } else {
        VStack {
          Text("Radio must be connected").font(.title).foregroundColor(.red)
          Text("to use Tx Settings").font(.title).foregroundColor(.red)
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
  
  enum Focusable: String, Hashable, Equatable {
    case accTx
    case rcaTx1
    case rcaTx2
    case rcaTx3
    case timeout
    case txDelay
  }
  @FocusState private var hasFocus: Focusable?

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
          send: { .setInterlockState(.rca, $0) } )) {
            ForEach(interlockLevels, id: \.self) {
              Text($0).tag($0)
            }
          }
          .pickerStyle(.menu)
          .frame(width: 180)

        Picker("ACC", selection: viewStore.binding(
          get: {_ in interlockLevels[accSelection]  },
          send: { .setInterlockState(.acc, $0) } )) {
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
            send: { .setInterlockBool(.tx1Enabled, $0) } ))
          TextField("tx1 delay", value: viewStore.binding(
            get: {_ in  interlock.tx1Delay},
            send: { .setInterlockInt(.tx1Delay, $0) } ), format: .number)
          .focused($hasFocus, equals: .rcaTx1)
          .multilineTextAlignment(.trailing)

        }
        HStack {
          Toggle("ACC TX", isOn: viewStore.binding(
            get: {_ in  interlock.accTxEnabled },
            send: { .setInterlockBool(.accTxEnabled, $0) } ))
          TextField("acc delay", value: viewStore.binding(
            get: {_ in  interlock.accTxDelay},
            send: { .setInterlockInt(.accTxDelay, $0) } ), format: .number)
          .focused($hasFocus, equals: .accTx)
          .multilineTextAlignment(.trailing)

        }
      }.frame(width: 180)
      
      GridRow() {
        HStack {
          Toggle("RCA TX2", isOn: viewStore.binding(
            get: {_ in  interlock.tx2Enabled},
            send: {.setInterlockBool(.tx2Enabled, $0) } ))
          TextField("tx2 delay", value: viewStore.binding(
            get: {_ in  interlock.tx2Delay },
            send: { .setInterlockInt(.tx2Delay, $0) } ), format: .number)
          .focused($hasFocus, equals: .rcaTx2)
          .multilineTextAlignment(.trailing)

        }
        HStack {
          Text("TX Delay").frame(width: 65, alignment: .leading)
          TextField("tx delay", value: viewStore.binding(
            get: {_ in  interlock.txDelay},
            send: { .setInterlockInt(.txDelay, $0) } ), format: .number)
          .focused($hasFocus, equals: .txDelay)
          .multilineTextAlignment(.trailing)

        }
      }.frame(width: 180)
      
      GridRow() {
        HStack {
          Toggle("RCA TX3", isOn: viewStore.binding(
            get: {_ in  interlock.tx3Enabled},
            send: { .setInterlockBool(.tx3Enabled, $0) } ))
          TextField("tx3 delay", value: viewStore.binding(
            get: {_ in  interlock.tx3Delay },
            send: { .setInterlockInt(.tx3Delay, $0) } ), format: .number)
          .focused($hasFocus, equals: .rcaTx3)
          .multilineTextAlignment(.trailing)

        }
        HStack {
          Text("Timeout (min)")
          TextField("minutes", value: viewStore.binding(
            get: {_ in  interlock.timeout },
            send: { .setInterlockInt(.timeout, $0) } ), format: .number)
          .focused($hasFocus, equals: .timeout)
          .multilineTextAlignment(.trailing)
        }
      }.frame(width: 180)
    }
    .onChange(of: hasFocus) { [hasFocus] _ in
      //        print("onChange: from \(hasFocus?.rawValue ?? "none") -> \(newValue?.rawValue ?? "none")")
      switch hasFocus {
      case .accTx:      viewStore.send(.sendInterlockProperty(.accTxDelay))
      case .rcaTx1:     viewStore.send(.sendInterlockProperty(.tx1Delay))
      case .rcaTx2:     viewStore.send(.sendInterlockProperty(.tx2Delay))
      case .rcaTx3:     viewStore.send(.sendInterlockProperty(.tx3Delay))
      case .timeout:    viewStore.send(.sendInterlockProperty(.timeout))
      case .txDelay:    viewStore.send(.sendInterlockProperty(.txDelay))
      default:          break
      }
    }
  }
}

private struct TxGridView: View {
  let viewStore: ViewStore<TxSettingsFeature.State, TxSettingsFeature.Action>
  @ObservedObject var interlock: Interlock
  @ObservedObject var txProfile: Profile
  @ObservedObject var transmit: Transmit
  
  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 40, verticalSpacing: 20) {
      
      GridRow() {
        Toggle("TX Inhibit", isOn: viewStore.binding(
          get: {_ in  transmit.inhibit },
          send: { .setTransmitBool(.inhibit, $0) } ))
        .toggleStyle(.checkbox)
        Toggle("TX in Waterfall", isOn: viewStore.binding(
          get: {_ in  transmit.txInWaterfallEnabled},
          send: { .setTransmitBool(.txInWaterfallEnabled, $0) } ))
        .toggleStyle(.checkbox)
        Text("Tx Profile")
        Picker("", selection: viewStore.binding(
          get: {_ in  txProfile.current},
          send: { .txProfile($0) })) {
            ForEach(txProfile.list, id: \.self) {
              Text($0).tag($0)
            }
          }
          .labelsHidden()
          .pickerStyle(.menu)
          .frame(width: 180)
      }
      GridRow() {
        Text("Max Power")
        HStack {
          Text("\(String(format: "%3d", transmit.maxPowerLevel))")
          Slider(value: viewStore.binding(
            get: {_ in  Double(transmit.maxPowerLevel) },
            send: { .maxPowerLevel(Int($0)) } ), in: 0...100).frame(width: 150)
        }.gridCellColumns(2)
        Toggle("Hardware ALC", isOn: viewStore.binding(
          get: {_ in  transmit.hwAlcEnabled},
          send: { .setTransmitBool(.hwAlcEnabled, $0) } ))
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
