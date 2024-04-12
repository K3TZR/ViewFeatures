//
//  EqView.swift
//  ViewFeatures/EqFeature
//
//  Created by Douglas Adams on 4/27/22.
//

import SwiftUI

import FlexApi
import SettingsModel
import SharedModel

// ----------------------------------------------------------------------------
// MARK: - View

public struct EqView: View {
  
  @Environment(ApiModel.self) private var apiModel
  @Environment(SettingsModel.self) private var settings

  public init() {}
  
 @MainActor private var equalizer: Equalizer {
    apiModel.equalizers[id: "rxsc"]!
  }
  
  public var body: some View {
    
    VStack(alignment: .leading, spacing: 10) {
      HeadingView(equalizer: equalizer)
      HStack(spacing: 20) {
        ButtonView(equalizer: equalizer)
        SliderView(equalizer: equalizer)
      }
      Divider().background(.blue)
    }
  }
}

private struct HeadingView: View {
  var equalizer: Equalizer

  var body: some View {

    HStack(spacing: 0) {
      Button( action: { equalizer.flat() }) { Text("Flat") }
      Text("").frame(width: 15)
      Group {
        Text("63")
        Text("125")
        Text("250")
        Text("500")
        Text("1k")
        Text("2k")
        Text("4k")
        Text("8k")
      }.frame(width:25)
    }
  }
}

private struct ButtonView: View {
  var equalizer: Equalizer
  
  var body: some View {

    VStack(alignment: .center, spacing: 25) {
      Text("+10 Db")
      Group {
        Toggle("On", isOn: Binding(
          get: { equalizer.eqEnabled } ,
          set: { equalizer.setProperty(.eqEnabled, $0.as1or0) } ))
        Toggle("Rx", isOn: Binding(
          get: { false },
          set: {_,_ in } )) // FIXME:
        Toggle("Tx", isOn: Binding(
          get: { false },
          set: {_,_ in } )) // FIXME:
      }.toggleStyle(.button)
      Text("-10 Db")
    }
  }
}

private struct SliderView: View {
  var equalizer: Equalizer
  
  var body: some View {
    
    VStack(alignment: .center, spacing: 5) {
      Group {
        Slider(value: Binding(get: { Double(equalizer.hz63)}, set: { equalizer.setProperty(.hz63, String(Int($0))) }), in: -10...10, step: 1)
        Slider(value: Binding(get: { Double(equalizer.hz125)}, set: { equalizer.setProperty(.hz125, String(Int($0))) }), in: -10...10, step: 1)
        Slider(value: Binding(get: { Double(equalizer.hz250)}, set: { equalizer.setProperty(.hz250, String(Int($0))) }), in: -10...10, step: 1)
        Slider(value: Binding(get: { Double(equalizer.hz500)}, set: { equalizer.setProperty(.hz500, String(Int($0))) }), in: -10...10, step: 1)
        Slider(value: Binding(get: { Double(equalizer.hz1000)}, set: { equalizer.setProperty(.hz1000, String(Int($0))) }), in: -10...10, step: 1)
        Slider(value: Binding(get: { Double(equalizer.hz2000)}, set: { equalizer.setProperty(.hz2000, String(Int($0))) }), in: -10...10, step: 1)
        Slider(value: Binding(get: { Double(equalizer.hz4000)}, set: { equalizer.setProperty(.hz4000, String(Int($0))) }), in: -10...10, step: 1)
        Slider(value: Binding(get: { Double(equalizer.hz8000)}, set: { equalizer.setProperty(.hz8000, String(Int($0))) }), in: -10...10, step: 1)
      }
      .frame(width: 180)
    }
    .rotationEffect(.degrees(-90), anchor: .center)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

#Preview("Rx Equalizer")  {
  EqView()
    .frame(width: 275, height: 250)
}

#Preview("Tx Equalizer")  {
  EqView()
    .frame(width: 275, height: 250)
}
