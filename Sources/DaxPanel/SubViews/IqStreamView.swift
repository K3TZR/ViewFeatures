//
//  IqStreamView.swift
//
//
//  Created by Douglas Adams on 11/28/23.
//

import SwiftUI

//public struct IqStreamView: View {
//  let title: String
//  
//  @State var oneIsOn = true
//  @State var twoIsOn = false
//  @State var threeIsOn = false
//  @State var fourIsOn = false
//
//  public var body: some View {
//    GroupBox() {
//      VStack(alignment: .leading) {
//        HStack(spacing: 60) {
//          Text(title)
//          Text("Rate")
//          Text("Streaming")
//          Spacer()
//        }
//
//        DetailView(buttonLabel: "1", isOn: $oneIsOn)
//        DetailView(buttonLabel: "2", isOn: $twoIsOn)
//        DetailView(buttonLabel: "3", isOn: $threeIsOn)
//        DetailView(buttonLabel: "4", isOn: $fourIsOn)
//      }
//    }
//  }
//}

public struct IqStreamView: View {
  let buttonLabel: String
  @Binding var isOn: Bool

  @State var streams = [1, 2, 3, 4]
  @State var sampleRates = [48_000, 96_000, 192_000]
  @State var selectedsampleRate = 48_000
  @State var isStreaming = true
  @State var frequency: Double = 14.250000

  private var frequencyText: String {
    isOn ? String(format: "%2.6f",frequency) : ""
  }
  
  public var body: some View {
    Divider()
    Grid(alignment: .leading) {
      GridRow {
        Text("IQ")
        Text("")
        Text("Rate").font(.footnote)
        Text("Streaming").font(.footnote)
      }
      GridRow {
        Divider()
      }
      
      ForEach(streams, id: \.self) { number in
        GridRow {
          Toggle(isOn: $isOn) {
            Text(String(number)).frame(width: 20)
          }
          .toggleStyle(.button)
          
          Text(frequencyText)
            .font(.footnote)
            .frame(width: 60, alignment: .leading)
          
  //        Text("Rate")
          
          Picker("", selection: $selectedsampleRate) {
            ForEach(sampleRates, id: \.self) {
              Text("\($0)").tag($0)
            }
          }
          .controlSize(.small)
          .labelsHidden()
          .pickerStyle(MenuPickerStyle())
          .frame(width: 70)
          
          Toggle("", isOn: $isStreaming)
            .disabled(true)
        }
      }
    }
  }
}

#Preview {
  IqStreamView(buttonLabel: "1", isOn: .constant(true))
    .frame(width: 275)
}
