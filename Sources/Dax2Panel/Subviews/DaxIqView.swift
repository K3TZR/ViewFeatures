//
//  DaxIqView.swift
//
//
//  Created by Douglas Adams on 11/29/23.
//

import AVFoundation
import SwiftUI

import SharedModel

struct DaxIqView: View {
  let devices: [AudioDevice]
  
  @State var isOn = false
  @State var selectedOutputDevice: AudioDeviceID?
  @State var daxChannels = [0, 1, 2, 3, 4]
  @State var sampleRates = [48_000, 96_000, 192_000]
  @State var selectedDaxChannel: Int?
  @State var selectedSampleRate: Int?
  @State var gain: Double = 40
  @State var status = "Off"
  
  var body: some View {
    GroupBox("DAX IQ Settings") {
      Grid(alignment: .leading, horizontalSpacing: 30) {
        
        GridRow {
          Text("Channel:")
          Picker("", selection: $selectedDaxChannel) {
            ForEach(daxChannels, id: \.self) {
              Text("\($0)").tag($0)
            }
          }
          .frame(width: 50)
          .labelsHidden()
        }
        
        GridRow {
          Toggle(isOn: $isOn, label: { Text("Enable IQ") })
          HStack {
            Text("Status:")
            Text(status)
          }
        }
        
        GridRow {
          Text("Sample Rate:")
          Picker("", selection: $selectedSampleRate) {
            ForEach(daxChannels, id: \.self) {
              Text("\($0)").tag($0)
            }
          }
          .frame(width: 120)
          .labelsHidden()
        }
        
       GridRow {
          Text("Output Device:")
          Picker("", selection: $selectedOutputDevice) {
            ForEach(devices, id: \.id) {
              if $0.hasOutput { Text($0.name!).tag($0.id) }
            }
          }
          .frame(width: 120)
          .labelsHidden()
        }
        
        GridRow {
          Slider(value: $gain, in: 0...100, label: {Text("Gain")})
        }.gridCellColumns(2)
        
        GridRow {
        }
      }
    }
//    .groupBoxStyle(PlainGroupBoxStyle())
  }
}

#Preview {
  DaxIqView(devices: [AudioDevice]())
    .frame(minWidth: 275, maxWidth: 275, minHeight: 120, maxHeight: .infinity)
    .padding()
}
