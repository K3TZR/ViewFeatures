//
//  RadioSettingsView.swift
//  xMini6001
//
//  Created by Douglas Adams on 5/13/21.
//

import ComposableArchitecture
import SwiftUI

import Objects
import Shared

struct RadioSettingsView: View {
  let store: StoreOf<RadioSettingsFeature>
  @ObservedObject var radio: Radio
  
  @Dependency(\.apiModel) var apiModel
  
  private let regions = ["USA", "Other"]
  private let screensavers = ["Model", "Callsign", "Nickname"]
  
  var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      if apiModel.radio == nil {
        VStack {
          Text("Radio must be connected").font(.title).foregroundColor(.red)
          Text("to use Radio Settings").font(.title).foregroundColor(.red)
        }

      } else {
        VStack {
          Group {
            RadioGridView(viewStore: viewStore, radio: radio)
            Spacer()
            Divider().foregroundColor(.blue)
            Spacer()
            ButtonsGridView(viewStore: viewStore, radio: radio)
            Spacer()
            Divider().foregroundColor(.blue)
          }
          Group {
            Spacer()
            CalibrationGridView(viewStore: viewStore, radio: radio)
            Spacer()
          }
        }
      }
    }
  }
}

private struct RadioGridView: View {
  let viewStore: ViewStore<RadioSettingsFeature.State, RadioSettingsFeature.Action>
  @ObservedObject var radio: Radio
  
  private let width: CGFloat = 150
  
  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: 10) {
      GridRow() {
        Text("Serial Number")
        Text(radio.packet?.serial ?? "")
      }
      GridRow() {
        Text("Hardware Version")
        Text("v" + (radio.hardwareVersion ?? ""))
        Text("Firmware Version")
        Text("v" + (radio.softwareVersion))
      }
      GridRow() {
        Text("Model")
        Text(radio.radioModel)
        Text("Options")
        Text(radio.radioOptions)
      }
      GridRow() {
        Text("Region")
        Picker("", selection: viewStore.binding(
          get: {_ in  radio.region },
          send: { .region($0) })) {
            ForEach(radio.regionList, id: \.self) {
              Text($0).tag($0)
            }
          }
          .labelsHidden()
          .pickerStyle(.menu)
          .frame(width: width)
        
        Text("Screen saver")
        Picker("", selection: viewStore.binding(
          get: {_ in  radio.radioScreenSaver },
          send: { .screenSaver($0) })) {
            ForEach(["model","nickname","callsign"] , id: \.self) {
              Text($0).tag($0)
            }
          }
          .labelsHidden()
          .pickerStyle(.menu)
          .frame(width: width)
      }
      GridRow() {
        Text("Callsign")
        TextField("Callsign", text: viewStore.binding(
          get: {_ in  radio.callsign },
          send: { .callsign($0) }))
        .frame(width: width)
        
        Text("Nickname")
        TextField("Nickname", text: viewStore.binding(
          get: {_ in  radio.nickname },
          send: { .nickname($0) }))
        .frame(width: width)
      }
    }
  }
}

private struct ButtonsGridView: View {
  let viewStore: ViewStore<RadioSettingsFeature.State, RadioSettingsFeature.Action>
  @ObservedObject var radio: Radio
  
  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: 10) {
      GridRow() {
        Toggle("Remote On", isOn: viewStore.binding(
          get: {_ in radio.remoteOnEnabled },
          send: .remoteOnButton ))
        Toggle("Flex Control", isOn: viewStore.binding(
          get: {_ in radio.flexControlEnabled },
          send: .flexControlButton ))
        Toggle("Mute audio (remote)", isOn: viewStore.binding(
          get: {_ in  radio.muteLocalAudio },
          send: .muteLocalAudioButton ))
        Toggle("Binaural audio", isOn: viewStore.binding(
          get: {_ in  radio.binauralRxEnabled },
          send: .binauralRxButton ))
      }
      GridRow() {
        Toggle("Snap to tune step", isOn: viewStore.binding(
          get: {_ in  radio.snapTuneEnabled},
          send: .snapTuneButton ))
        Toggle("Single click to tune", isOn: viewStore.binding(
          get: {_ in  false },
          send: .singleClickButton ))
        .disabled(true)
        Toggle("Start slices minimized", isOn: viewStore.binding(
          get: {_ in  false },
          send: .sliceMinimizedButton ))
        .disabled(true)
      }
    }
  }
}

private struct CalibrationGridView: View {
  let viewStore: ViewStore<RadioSettingsFeature.State, RadioSettingsFeature.Action>
  @ObservedObject var radio: Radio
  
  private let width: CGFloat = 140
  
  var body: some View {
    Grid(alignment: .center, horizontalSpacing: 25, verticalSpacing: 10) {
      GridRow() {
        Text("Frequency")
        TextField("", text: viewStore.binding(
          get: {_ in  String(radio.calFreq) },
          send: { .calibrationFrequency(Int($0) ?? 0) }))
        .frame(width: width)
        .multilineTextAlignment(.trailing)
        
        Button("Calibrate") { viewStore.send(.calibrateButton) }
        
        Text("Offset (ppb)")
        TextField("", text: viewStore.binding(
          get: {_ in  String(radio.freqErrorPpb) },
          send: { .calibrationError(Int($0) ?? 0) }))
        .frame(width: width)
        .multilineTextAlignment(.trailing)
      }
    }
  }
}

struct RadioSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    RadioSettingsView(store: Store(initialState: RadioSettingsFeature.State(), reducer: RadioSettingsFeature()), radio: Radio(Packet()))
      .frame(width: 600, height: 350)
      .padding()
  }
}
