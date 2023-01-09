//
//  PhoneCwSettingsView.swift
//  xMini6001
//
//  Created by Douglas Adams on 5/13/21.
//

import ComposableArchitecture
import SwiftUI

import Objects
import Shared

struct PhoneCwSettingsView: View {
  let store: StoreOf<PhoneCwSettingsFeature>
  @Dependency(\.apiModel) var apiModel
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      if apiModel.radio == nil {
        VStack {
          Text("Radio must be connected").font(.title).foregroundColor(.red)
          Text("to use PhoneCw Settings").font(.title).foregroundColor(.red)
        }

      } else {
        VStack(spacing: 10) {
          Group {
            MicGridView(viewStore: viewStore, transmit: apiModel.transmit)
            Spacer()
            Divider().foregroundColor(.blue)
          }
          Group {
            Spacer()
            CwGridView(viewStore: viewStore, transmit: apiModel.transmit)
            Spacer()
            Divider().foregroundColor(.blue)
          }
          Group {
            Spacer()
            RttyGridView(viewStore: viewStore, radio: apiModel.radio ?? Radio(Packet()))
            Spacer()
            Divider().foregroundColor(.blue)
          }
          Group {
            Spacer()
            FiltersGridView(viewStore: viewStore, radio: apiModel.radio ?? Radio(Packet()))
            Spacer()
          }
        }
      }
    }
  }
}

private struct MicGridView: View {
  let viewStore: ViewStore<PhoneCwSettingsFeature.State, PhoneCwSettingsFeature.Action>
  @ObservedObject var transmit: Transmit
  
  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 80, verticalSpacing: 20) {
      GridRow() {
        Toggle("Microphone bias", isOn: viewStore.binding(
          get: {_ in transmit.micBiasEnabled },
          send: { .setTransmitBool(.micBiasEnabled, $0) } ))
        Toggle("Mic level during receive", isOn: viewStore.binding(
          get: {_ in transmit.meterInRxEnabled },
          send: { .setTransmitBool(.meterInRxEnabled, $0) } ))
        Toggle("+20 db Mic gain", isOn: viewStore.binding(
          get: {_ in transmit.micBoostEnabled },
          send: {.setTransmitBool(.micBoostEnabled, $0) } ))
      }
    }
  }
}

private struct CwGridView: View {
  let viewStore: ViewStore<PhoneCwSettingsFeature.State, PhoneCwSettingsFeature.Action>
  @ObservedObject var transmit: Transmit
  
  private let iambicModes = ["A", "B"]
  private let cwSidebands = ["Upper", "Lower"]
  
  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 60, verticalSpacing: 20) {
      GridRow() {
        Toggle("Iambic", isOn: viewStore.binding(
          get: {_ in transmit.cwIambicEnabled },
          send: {.setTransmitBool(.cwIambicEnabled, $0) } ))
        
        Picker("", selection: viewStore.binding(
          get: {_ in transmit.cwIambicMode == 0 ? "A" : "B"},
          send: { .setTransmitString(.cwIambicMode, ($0 == "B").as1or0) } )) {
            ForEach(iambicModes, id: \.self) {
              Text($0).tag($0)
            }
          }
          .labelsHidden()
          .pickerStyle(.segmented)
          .frame(width: 110)
        
        Toggle("Swap dot / dash", isOn: viewStore.binding(
          get: {_ in transmit.cwSwapPaddles },
          send: {.setTransmitBool(.cwSwapPaddles, $0) } ))
        
        Toggle("CWX sync", isOn: viewStore.binding(
          get: {_ in transmit.cwSyncCwxEnabled },
          send: {.setTransmitBool(.cwSyncCwxEnabled, $0) } ))
      }
      
      GridRow {
        Text("CW Sideband")
        Picker("", selection: viewStore.binding(
          get: {_ in transmit.cwlEnabled ? "Lower" : "Upper" },
          send: { .setTransmitString(.cwlEnabled, ($0 == "Lower").as1or0) } )) {
            ForEach(cwSidebands, id: \.self) {
              Text($0).tag($0)
            }
          }
          .labelsHidden()
          .pickerStyle(.segmented)
          .frame(width: 110)
      }
    }
  }
}

private struct FiltersGridView: View {
  let viewStore: ViewStore<PhoneCwSettingsFeature.State, PhoneCwSettingsFeature.Action>
  @ObservedObject var radio: Radio
  
  var body: some View {
    Grid(horizontalSpacing: 20, verticalSpacing: 5) {
      GridRow() {
        Text("Voice")
        Text(radio.filterVoiceLevel, format: .number)
        Slider(value: viewStore.binding(
          get: {_ in  Double(radio.filterVoiceLevel) },
          send: { .setFilterInt(.voice, Int($0)) }), in: 0...3, step: 1).frame(width: 250)
        Toggle("Auto", isOn: viewStore.binding(
          get: {_ in  radio.filterVoiceAutoEnabled },
          send: .setFilterBool(.voice) ))
      }
      GridRow() {
        Text("CW")
        Text(radio.filterCwLevel, format: .number)
        Slider(value: viewStore.binding(
          get: {_ in  Double(radio.filterCwLevel) },
          send: { .setFilterInt(.cw, Int($0)) }), in: 0...3, step: 1).frame(width: 250)
        Toggle("Auto", isOn: viewStore.binding(
          get: {_ in  radio.filterCwAutoEnabled },
          send: .setFilterBool(.cw) ))
      }
      GridRow() {
        Text("Digital")
        Text(radio.filterDigitalLevel, format: .number)
        Slider(value: viewStore.binding(
          get: {_ in  Double(radio.filterDigitalLevel) },
          send: { .setFilterInt(.digital, Int($0)) }), in: 0...3, step: 1).frame(width: 250)
        Toggle("Auto", isOn: viewStore.binding(
          get: {_ in  radio.filterDigitalAutoEnabled },
          send: .setFilterBool(.digital) ))
      }
    }
  }
}

private struct RttyGridView: View {
  let viewStore: ViewStore<PhoneCwSettingsFeature.State, PhoneCwSettingsFeature.Action>
  @ObservedObject var radio: Radio

  enum Focusable: String, Hashable, Equatable {
    case rttyMark
  }

  @FocusState private var hasFocus: Focusable?

  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 20) {
      GridRow() {
        Text("RTTY Mark default").frame(width: 115, alignment: .leading)
        TextField("", text: viewStore.binding(
          get: {_ in String(radio.rttyMark) },
          send: { .setRadioString(.rttyMark, $0) } ))
        .focused($hasFocus, equals: .rttyMark)
        .onSubmit { viewStore.send(.sendRadioProperty(.rttyMark)) }
        .frame(width: 100)
        .multilineTextAlignment(.trailing)
      }
    }
    .onChange(of: hasFocus) {_ in
      //        print("onChange: from \(hasFocus?.rawValue ?? "none") -> \(newValue?.rawValue ?? "none")")
      viewStore.send(.sendRadioProperty(.rttyMark))
    }
  }
}

struct PhoneCwSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    PhoneCwSettingsView(store: Store(
      initialState: PhoneCwSettingsFeature.State(),
      reducer: PhoneCwSettingsFeature())
    )
    .frame(width: 600, height: 350)
    .padding()
  }
}
