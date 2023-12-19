//
//  ControlView.swift
//  ControlFeatures/ControlFeature
//
//  Created by Douglas Adams on 11/13/22.
//

import SwiftUI

import FlexApi
import Flag
import SettingsModel

// ----------------------------------------------------------------------------
// MARK: - View

public struct SideView: View {
  
  public init() {}
  
  @Environment(ApiModel.self) private var apiModel
  @Environment(SettingsModel.self) private var settings

  private func toggleOption(_ option: SettingsModel.SidePanelOptions) {
    if settings.sidePanelOptions.contains(option) {
      settings.sidePanelOptions.remove(option)
    } else {
      settings.sidePanelOptions.insert(option)
    }
    
  }
  
  public var body: some View {
    
    VStack(alignment: .center) {
      HStack {
        ControlGroup {
          //            Toggle("Rx", isOn: viewStore.binding(get: { $0.rxState != nil }, send: .rxButton ))
          Toggle("Tx", isOn: Binding(get: { settings.sidePanelOptions.contains(.tx) }, set: {_,_  in toggleOption(.tx) } ))
          Toggle("Ph1", isOn: Binding(get: { settings.sidePanelOptions.contains(.ph1)  }, set: {_,_  in toggleOption(.ph1) } ))
          Toggle("Ph2", isOn: Binding(get: { settings.sidePanelOptions.contains(.ph2)  }, set: {_,_  in toggleOption(.ph2) } ))
          Toggle("Cw", isOn: Binding(get: { settings.sidePanelOptions.contains(.cw)  }, set: {_,_  in toggleOption(.cw) } ))
          Toggle("Eq", isOn: Binding(get: { settings.sidePanelOptions.contains(.eq)  }, set: {_,_  in toggleOption(.eq) } ))
        }
        .frame(width: 280)
        .disabled(apiModel.clientInitialized == false)
      }
      Spacer()
      
      ScrollView {
        if apiModel.clientInitialized {
          VStack {
            if settings.sidePanelOptions.contains(.tx) { TxView() }
            if settings.sidePanelOptions.contains(.ph1) { Ph1View() }
            if settings.sidePanelOptions.contains(.ph2) { Ph2View() }
            if settings.sidePanelOptions.contains(.cw) { CwView() }
            if settings.sidePanelOptions.contains(.eq) { EqView() }
          }
          .padding(.horizontal, 10)
          
        } else {
          EmptyView()
        }
      }
      //      .onChange(of: apiModel.clientInitialized) {
      //        viewStore.send(.openClose($1))
      //      }
    }
    .frame(width: 275)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

#Preview("Tx") {
  SideView()
    .environment(ApiModel.shared)
    .environment(SettingsModel.shared)
    .frame(width: 275)
}

#Preview("Eq") {
  SideView()
    .environment(ApiModel.shared)
    .environment(SettingsModel.shared)
    .frame(width: 275)
}

#Preview("Ph1") {
  SideView()
    .environment(ApiModel.shared)
    .environment(SettingsModel.shared)
    .frame(width: 275)
}

#Preview("Ph2") {
  SideView()
    .environment(ApiModel.shared)
    .environment(SettingsModel.shared)
    .frame(width: 275)
}

#Preview("CW") {
  SideView()
    .environment(ApiModel.shared)
    .environment(SettingsModel.shared)
    .frame(width: 275)
}

#Preview("ALL") {
  SideView()
    .environment(ApiModel.shared)
    .environment(SettingsModel.shared)
    .frame(width: 275, height: 1200)
}
