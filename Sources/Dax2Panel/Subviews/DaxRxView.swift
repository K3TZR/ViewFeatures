//
//  DaxRxView.swift
//
//
//  Created by Douglas Adams on 11/29/23.
//

import AVFoundation
import SwiftUI

import FlexApi
//import LabeledGaugeView
import LevelIndicatorView
import SettingsModel
import SharedModel

struct DaxRxView: View {
  let devices: [AudioDevice]
  
  @Environment(SettingsModel.self) var settings
  
  private let channels = [0,1,2,3,4,5,6,7,8]
  
  var body: some View {
    @Bindable var bindableSettings = settings
    
    GroupBox("DAX RX Settings") {
      VStack(alignment: .leading) {
        Grid(alignment: .leading, horizontalSpacing: 10) {
          GridRow {
            Toggle(isOn: $bindableSettings.daxRxSetting.enabled,
                   label: { Text("Enable") }).disabled(settings.daxRxSetting.deviceID == nil)
            Picker("Channel:", selection: $bindableSettings.daxRxSetting.channel) {
              Text("").tag(0)
              ForEach(channels, id: \.self) {
                Text("\($0)").tag($0)
              }
            }
          }
          
          Divider()
          
          GridRow {
            Text("Output Device:")
            Picker("", selection: $bindableSettings.daxRxSetting.deviceID) {
              Text("none").tag(nil as AudioDeviceID?)
              ForEach(devices, id: \.id) {
                if $0.hasOutput { Text($0.name!).tag($0.id as AudioDeviceID?) }
              }
            }
            .labelsHidden()
          }
          
          GridRow {
            HStack {
              Text("Gain:")
              Text("\(Int(settings.daxRxSetting.gain))").frame(width: 40, alignment: .trailing)
            }
            Slider(value: $bindableSettings.daxRxSetting.gain, in: 0...100)
          }
        }
        LevelIndicatorView(levels: DaxModel.shared.daxRxAudioPlayer?.levels ?? SignalLevel(rms: -40, peak: -40), type: .dax)
        
        HStack {
          Text("Status:")
          Text(DaxModel.shared.status)
        }
      }
      
      // DEVICE change
      .onChange(of: settings.daxRxSetting.deviceID) {_, newValue in
        if newValue != nil {
          print("----->>>>> New AudioDeviceID", newValue!)
          DaxModel.shared.setDevice(settings.daxRxSetting.channel, newValue!)
          
        } else {
          print("----->>>>> New AudioDeviceID", "none")
        }
      }
      
      // ENABLED change
      .onChange(of: settings.daxRxSetting.enabled) {_, newValue in
        if newValue {
          DaxModel.shared.startDaxRxAudio(settings.daxRxSetting.deviceID!, settings.daxRxSetting.channel)
        } else {
          DaxModel.shared.stopDaxRxAudio(settings.daxRxSetting.channel)
        }
      }
      
      // GAIN change
      .onChange(of: settings.daxRxSetting.gain) {_, newValue in
        DaxModel.shared.setGain(channel: settings.daxRxSetting.channel, gain: settings.daxRxSetting.gain)
      }
    }
  }
}

#Preview {
  DaxRxView(devices: [AudioDevice]())
    .environment(SettingsModel.shared)
    .frame(minWidth: 275, maxWidth: 275, minHeight: 120, maxHeight: .infinity)
    .padding()
}
