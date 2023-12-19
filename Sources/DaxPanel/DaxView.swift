//
//  DaxView.swift
//  Sdr6000
//
//  Created by Douglas Adams on 11/27/23.
//

import AVFoundation
import SwiftUI

import SwiftUI

import FlexApi
import Flag
import SettingsModel

// ----------------------------------------------------------------------------
// MARK: - View

public struct DaxView: View {
  
  public init() {}
  
  @Environment(ApiModel.self) private var apiModel
  @Environment(SettingsModel.self) private var settings
  
  @State var txIsOn = false
  @State var micIsOn = false
  @State var rxIsOn = true
  @State var iqIsOn = false

  private func toggleOption(_ option: SettingsModel.DaxPanelOptions) {
    if settings.daxPanelOptions.contains(option) {
      settings.daxPanelOptions.remove(option)
    } else {
      settings.daxPanelOptions.insert(option)
    }
  }
  
  public var body: some View {
    
    VStack(alignment: .center) {
      HStack {
        ControlGroup {
          Toggle("Tx", isOn: Binding(get: { settings.daxPanelOptions.contains(.tx) }, set: {_,_  in toggleOption(.tx) } ))
          Toggle("Mic", isOn: Binding(get: { settings.daxPanelOptions.contains(.mic)  }, set: {_,_  in toggleOption(.mic) } ))
          Toggle("Rx", isOn: Binding(get: { settings.daxPanelOptions.contains(.rx)  }, set: {_,_  in toggleOption(.rx) } ))
          Toggle("IQ", isOn: Binding(get: { settings.daxPanelOptions.contains(.iq)  }, set: {_,_  in toggleOption(.iq) } ))
        }
        .frame(width: 280)
      }
      Spacer()
      
      ScrollView {
        VStack {
          if settings.daxPanelOptions.contains(.tx) { DaxAudioView(title: "Tx", buttonLabel: "TX", isOn: $txIsOn, hasSlice: false) }
          if settings.daxPanelOptions.contains(.mic) { DaxAudioView(title: "Mic", buttonLabel: "Mic", isOn: $micIsOn, hasSlice: false) }
          if settings.daxPanelOptions.contains(.rx) {
            DaxAudioView(title: "Rx", buttonLabel: "1", isOn: $rxIsOn, hasSlice: true)
          }
          if settings.daxPanelOptions.contains(.iq) { IqStreamView(buttonLabel: "1", isOn: .constant(true)) }
        }
        .padding(.horizontal, 10)
        
      }.scrollIndicators(.visible, axes: .vertical)
    }
    .frame(minWidth: 275, maxWidth: 275, minHeight: 120, maxHeight: .infinity)
    .padding()
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

#Preview {
  DaxView()
    .environment(ApiModel.shared)
    .environment(SettingsModel.shared)
    .frame(minWidth: 275, maxWidth: 275, minHeight: 120, maxHeight: .infinity)
    .padding()
}
