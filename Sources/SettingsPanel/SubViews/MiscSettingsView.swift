//
//  MiscSettingsView.swift
//
//
//  Created by Douglas Adams on 3/1/23.
//

import SwiftUI

import ApiStringView
import FlexApi
import SettingsModel

public struct MiscSettingsView: View {

  @Environment(ApiModel.self) private var apiModel
  @Environment(SettingsModel.self) private var settings

  public init() {}

  public var body: some View {
    @Bindable var settingsBindable = settings

    VStack {
      Picker("Monitor meter", selection: $settingsBindable.monitorShortName) {
        ForEach(Meter.ShortName.allCases, id: \.self) { shortName in
          Text(shortName.rawValue).tag(shortName.rawValue)
        }
      }
      .labelsHidden()
      .pickerStyle(.menu)
      .frame(width: 100, alignment: .leading)
      
      Spacer()
      Toggle("Log Broadcasts", isOn: $settingsBindable.logBroadcasts)
      Toggle("Ignore TimeStamps", isOn: $settingsBindable.ignoreTimeStamps)
      Toggle("Alert on Error / Warning", isOn: $settingsBindable.alertOnError)
      
      Spacer()
      
//      VStack {
//        Text("Custom Antenna Names")
//        Divider()
//        Grid (verticalSpacing: 10) {
//          ForEach(apiModel.antList, id: \.self) { antenna in
//            GridRow {
//              Text(antenna)
//              ApiStringView(value: apiModel.altAntennaName(for: antenna), action: { apiModel.altAntennaName(for: antenna, $0) })
//            }.frame(width: 120)
//          }
//        }
//      }.frame(width: 200)
//      Spacer()
    }
  }
}

#Preview {
  MiscSettingsView()
}
