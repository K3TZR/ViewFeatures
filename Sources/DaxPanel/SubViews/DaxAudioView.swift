//
//  AudioDetailView.swift
//
//
//  Created by Douglas Adams on 11/28/23.
//

import SwiftUI

import LevelIndicatorView
import SharedModel

public struct DaxAudioView: View {
  let title: String
  let buttonLabel: String
  @Binding var isOn: Bool
  let hasSlice: Bool

  public var body: some View {
    VStack {
      HStack {
        Text(title)
        Spacer()
      }
      AudioDetailView(buttonLabel: buttonLabel, isOn: $isOn, hasSlice: hasSlice)
    }
  }
}

private struct AudioDetailView: View {
  let buttonLabel: String
  @Binding var isOn: Bool
  let hasSlice: Bool

  @State var gain: Double = 100
  @State var isStreaming = true
  @State var streamLevel = SignalLevel(rms: 80, peak: 95)
  @State var sliceLetter = "A"

  private var sliceText: String {
    hasSlice ? "Slice - " + sliceLetter : ""
  }
  
  public var body: some View {
    Divider()
    Grid (verticalSpacing: 10){
      GridRow {
        Toggle(isOn: $isOn) {
          Text(buttonLabel).frame(width: 30)
        }
        .frame(width: 40)
        .toggleStyle(.button)
        
        Text(sliceText)
          .font(.footnote)
          .frame(width: 55, alignment: .leading)
        
        HStack {
          Text("Gain").frame(width: 30, alignment: .leading)
          Slider(value: $gain, in: 0...100).frame(width: 100)
        }
      }
      
      GridRow {
        Text("\(isStreaming ? "Streaming" : "")")
          .font(.footnote)
          .frame(width: 50, alignment: .leading)
        Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
        LevelIndicatorView(levels: streamLevel, type: .dax)
      }
    }
  }
}

#Preview {
  DaxAudioView(title: "Rx Streams", buttonLabel: "1", isOn: .constant(true), hasSlice: true)
    .frame(width: 275)
  
}
