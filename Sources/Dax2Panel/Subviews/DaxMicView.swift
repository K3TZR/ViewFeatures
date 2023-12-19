//
//  SwiftUIView.swift
//  
//
//  Created by Douglas Adams on 11/29/23.
//

import AVFoundation
import SwiftUI

import SettingsModel
import SharedModel

struct DaxMicView: View {
  let devices: [AudioDevice]
  
  @State var status = "Off"
  
  @Environment(SettingsModel.self) var settings

  var body: some View {
    @Bindable var bindableSettings = settings

    GroupBox("DAX MIC Settings") {
      Grid(alignment: .topLeading, horizontalSpacing: 10) {
        
          GridRow {
            Toggle(isOn: $bindableSettings.daxMicSetting.enabled,
                   label: { Text("Enable") })
            HStack {
              Text("Status:")
              Text(status).frame(width: 40)
            }.gridColumnAlignment(.trailing)
          }

          GridRow {
            Text("Output Device:")
            Picker("", selection: $bindableSettings.daxMicSetting.deviceID) {
              Text("None").tag(nil as AudioDeviceID?)
              ForEach(devices, id: \.id) {
                if $0.hasOutput { Text($0.name!).tag($0.id as AudioDeviceID?) }
              }
            }
            .labelsHidden()
          }

          GridRow {
            HStack {
              Text("Gain:")
              Text("\(Int(settings.daxMicSetting.gain * 100))").frame(width: 40, alignment: .trailing)
            }
            Slider(value: $bindableSettings.daxMicSetting.gain, in: 0...1, label: {
            })
          }
      }
    }
//    .groupBoxStyle(PlainGroupBoxStyle())
  }
}



#Preview {
  DaxMicView(devices: [AudioDevice]())
    .environment(SettingsModel.shared)
    .frame(minWidth: 275, maxWidth: 275, minHeight: 120, maxHeight: .infinity)
    .padding()
}
