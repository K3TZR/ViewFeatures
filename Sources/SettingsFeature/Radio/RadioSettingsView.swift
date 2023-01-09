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
      if apiModel.clientInitialized {
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
      } else {
        VStack {
          Text("Radio must be connected").font(.title).foregroundColor(.red)
          Text("to use Radio Settings").font(.title).foregroundColor(.red)
        }
      }
    }
  }
}

private struct RadioGridView: View {
  let viewStore: ViewStore<RadioSettingsFeature.State, RadioSettingsFeature.Action>
  @ObservedObject var radio: Radio

  enum Focusable: String, Hashable, Equatable {
    case callsign
    case radioName
  }

  private let width: CGFloat = 150
  @FocusState private var hasFocus: Focusable?

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
          send: { .setRadioString(.region, $0) })) {
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
          send: { .setRadioString(.screensaver, $0) })) {
            ForEach(["Model","Name","Callsign"] , id: \.self) {
              Text($0).tag($0.lowercased())
            }
          }
          .labelsHidden()
          .pickerStyle(.menu)
          .frame(width: width)
      }
      GridRow() {
        Text("Callsign")
        TextField("", text: viewStore.binding(
          get: {_ in  radio.callsign },
          send: { .setRadioString(.callsign, $0) }))
          .focused($hasFocus, equals: .callsign)
          .onSubmit { viewStore.send(.sendRadioProperty(.callsign)) }
          .frame(width: width)
        
        Text("Radio Name")
        TextField("", text: viewStore.binding(
          get: {_ in  radio.name },
          send: { .setRadioString(.name, $0) }))
          .focused($hasFocus, equals: .radioName)
          .onSubmit { viewStore.send(.sendRadioProperty(.name)) }
          .frame(width: width)
      }
      .onChange(of: hasFocus) { [hasFocus] _ in
//        print("onChange: from \(hasFocus?.rawValue ?? "none") -> \(newValue?.rawValue ?? "none")")
        switch hasFocus {
        case .callsign:   viewStore.send(.sendRadioProperty(.callsign))
        case .radioName:  viewStore.send(.sendRadioProperty(.name))
        default:          break
        }
      }
    }
  }
}

private struct ButtonsGridView: View {
  let viewStore: ViewStore<RadioSettingsFeature.State, RadioSettingsFeature.Action>
  @ObservedObject var radio: Radio
  
  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 5, verticalSpacing: 10) {
      GridRow() {
        Toggle("Remote On", isOn: viewStore.binding(
          get: {_ in radio.remoteOnEnabled },
          send: .setRadioBool(.remoteOnEnabled) ))
        Toggle("Flex Control", isOn: viewStore.binding(
          get: {_ in radio.flexControlEnabled },
          send: .setRadioBool(.flexControlEnabled) ))
        Toggle("Mute audio (remote)", isOn: viewStore.binding(
          get: {_ in  radio.muteLocalAudio },
          send: .setRadioBool(.muteLocalAudio) ))
        Toggle("Binaural audio", isOn: viewStore.binding(
          get: {_ in  radio.binauralRxEnabled },
          send: .setRadioBool(.binauralRxEnabled) ))
      }.frame(width: 150, alignment: .leading)
      GridRow() {
        Toggle("Snap to tune step", isOn: viewStore.binding(
          get: {_ in  radio.snapTuneEnabled},
          send: .setRadioBool(.snapTuneEnabled) ))
        Toggle("Single click to tune", isOn: viewStore.binding(
          get: {_ in  false },
          send: .singleClickButton ))
        .disabled(true)
        Toggle("Start slices minimized", isOn: viewStore.binding(
          get: {_ in  false },
          send: .sliceMinimizedButton ))
        .gridCellColumns(2)
        .disabled(true)
      }
//      .frame(width: 150, alignment: .leading)
    }
  }
}

private struct CalibrationGridView: View {
  let viewStore: ViewStore<RadioSettingsFeature.State, RadioSettingsFeature.Action>
  @ObservedObject var radio: Radio
  
  private let width: CGFloat = 100
  enum Focusable: String, Hashable, Equatable {
    case frequency
    case error
  }
  @FocusState private var hasFocus: Focusable?

  var body: some View {
    
    Grid(alignment: .center, horizontalSpacing: 40, verticalSpacing: 10) {
      GridRow() {
        Text("Frequency (MHz)")
        TextField("", value: viewStore.binding(
          get: {_ in  radio.calFreq },
          send: { .setRadioString(.calFreq, String($0)) }), format: .number.precision(.fractionLength(6)))
          .focused($hasFocus, equals: .frequency)
          .onSubmit { viewStore.send(.sendRadioProperty(.calFreq)) }
          .multilineTextAlignment(.trailing)
          .frame(width: width)
        
        Button("Calibrate") { viewStore.send(.calibrateButton) }
        
        Text("Offset (ppb)")
        TextField("", value: viewStore.binding(
          get: {_ in  radio.freqErrorPpb },
          send: { .setRadioString(.freqErrorPpb, String($0)) }), format: .number)
          .focused($hasFocus, equals: .error)
          .onSubmit { viewStore.send(.sendRadioProperty(.freqErrorPpb)) }
          .multilineTextAlignment(.trailing)
          .frame(width: width)
      }
      .onChange(of: hasFocus) { [hasFocus] _ in
//        print("onChange: from \(hasFocus?.rawValue ?? "none") -> \(newValue?.rawValue ?? "none")")
        switch hasFocus {
        case .error:      viewStore.send(.sendRadioProperty(.freqErrorPpb))
        case .frequency:  viewStore.send(.sendRadioProperty(.calFreq))
        default:          break
        }
      }
    }
  }
}

struct RadioSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    RadioSettingsView(store: Store(initialState: RadioSettingsFeature.State(),
                                   reducer: RadioSettingsFeature()), radio: Radio(Packet()))
      .frame(width: 600, height: 350)
      .padding()
  }
}
