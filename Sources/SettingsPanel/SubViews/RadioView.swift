//
//  RadioView.swift
//  SettingsFeature/RadioFeature
//
//  Created by Douglas Adams on 5/13/21.
//

import SwiftUI

import ApiIntView
import ApiStringView
import FlexApi
import SettingsModel
//import SharedModel

public struct RadioView: View {
//  var apiModel: ApiModel

  public init() {}

  @Environment(ApiModel.self) private var apiModel

  private let regions = ["USA", "Other"]
  private let screensavers = ["Model", "Callsign", "Nickname"]
  
  public var body: some View {
    
    if apiModel.clientInitialized {
      VStack {
        Group {
          RadioGridView(radio: apiModel.radio!)
          Spacer()
          Divider().foregroundColor(.blue)
          Spacer()
          ButtonsGridView(radio: apiModel.radio!)
          Spacer()
          Divider().foregroundColor(.blue)
        }
        Group {
          Spacer()
          CalibrationGridView(radio: apiModel.radio!)
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

private struct RadioGridView: View {
  var radio: Radio

  private let width: CGFloat = 150

  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: 10) {
      GridRow() {
        Text("Serial Number")
        Text(radio.packet.serial )
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
        Picker("", selection: Binding(
          get: { radio.region },
          set: { radio.setProperty(.region, $0) })) {
            ForEach(radio.regionList, id: \.self) {
              Text($0).tag($0)
            }
          }
          .labelsHidden()
          .pickerStyle(.menu)
          .frame(width: width)
        
        Text("Screen saver")
        Picker("", selection: Binding(
          get: { radio.radioScreenSaver },
          set: { radio.setProperty(.screensaver, $0) })) {
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
        ApiStringView(value: radio.callsign, action: { _ in radio.setProperty(.callsign, radio.callsign) })

        Text("Radio Name")
        ApiStringView(value: radio.name, action: { _ in radio.setProperty(.name, radio.name) })
      }
    }
  }
}

private struct ButtonsGridView: View {
  var radio: Radio

  @Environment(SettingsModel.self) private var settings

  var body: some View {
    @Bindable var settingsBindable = settings

    Grid(alignment: .leading, horizontalSpacing: 5, verticalSpacing: 10) {
      GridRow() {
        Toggle("Remote On", isOn: Binding(
          get: { radio.remoteOnEnabled },
          set: { radio.setProperty(.remoteOnEnabled, $0.as1or0) } ))
        Toggle("Flex Control", isOn: Binding(
          get: { radio.flexControlEnabled },
          set: { radio.setProperty(.flexControlEnabled, $0.as1or0) } ))
        Toggle("Mute audio (remote)", isOn: Binding(
          get: { radio.muteLocalAudio },
          set: { radio.setProperty(.muteLocalAudio, $0.as1or0) } ))
        Toggle("Binaural audio", isOn: Binding(
          get: { radio.binauralRxEnabled },
          set: { radio.setProperty(.binauralRxEnabled, $0.as1or0) } ))
      }.frame(width: 150, alignment: .leading)
      
      GridRow() {
        Toggle("Snap to tune step", isOn: Binding(
          get: { radio.snapTuneEnabled},
          set: { radio.setProperty(.snapTuneEnabled, $0.as1or0) } ))
        Toggle("Single click tune", isOn: $settingsBindable.singleClickTuneEnabled)
        .disabled(true)
        Toggle("Slices minimized", isOn: $settingsBindable.sliceMinimizedEnabled)
        .disabled(true)
        Toggle("Open controls", isOn: $settingsBindable.openControls)
      }
    }
  }
}

private struct CalibrationGridView: View {
  var radio: Radio
  
  private let width: CGFloat = 100

  var body: some View {
    
    Grid(alignment: .center, horizontalSpacing: 40, verticalSpacing: 10) {
      GridRow() {
        Text("Frequency")
        ApiIntView(value: radio.calFreq, formatter: NumberFormatter.dotted, action: { stringFreq in radio.setProperty(.calFreq, stringFreq.toMhz) })

        Button("Calibrate") { radio.setProperty(.calibrate, "") }
        
        Text("Offset (ppb)")
        ApiIntView(value: radio.freqErrorPpb, action: { stringFreq in radio.setProperty(.freqErrorPpb, stringFreq) })
      }
    }
  }
}

#Preview {
  RadioView()
    .frame(width: 600, height: 350)
    .padding()
}
