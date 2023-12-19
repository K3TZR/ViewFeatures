//
//  ConnectionView.swift
//  
//
//  Created by Douglas Adams on 6/12/23.
//

import SwiftUI

import FlexApi
import SettingsModel

public struct ConnectionView: View {
    
  public init() {}
  
 public var body: some View {

    VStack(alignment: .leading) {
      HeadingView()
      Spacer()
      Divider().background(Color.blue)
      Spacer()
      ListHeadingView()
      Divider()
      ListView()
        .frame(height: 200)
    }
  }
}

private struct HeadingView: View {
  
  @Environment(SettingsModel.self) private var settings

  public var body: some View {
    @Bindable var settingsBindable = settings

    Grid(alignment: .leading, horizontalSpacing: 40){
        
      GridRow {
        Text("Station")
        TextField("Station name", text: $settingsBindable.stationName)
          .multilineTextAlignment(.trailing)
          .frame(width: 100)
        Toggle("Use Default radio", isOn: $settingsBindable.useDefault)
        Toggle("Login required", isOn: $settingsBindable.loginRequired)
      }
      GridRow {
        Text("MTU")
        TextField("MTU value", value: $settingsBindable.mtuValue, format: .number)
          .multilineTextAlignment(.trailing)
          .frame(width: 100)
        Toggle("RemoteRxAudio Compressed", isOn: $settingsBindable.remoteRxAudioCompressed)
        Toggle("Reduced DAX BW", isOn: $settingsBindable.daxReducedBandwidth)
      }
    }
  }
}

private struct ListHeadingView: View {

  public var body: some View {

    HStack {
      Spacer()
      Text("Direct Connect Radios").font(.title2).bold()
      Spacer()
    }
    HStack {
      Group {
        Text("Name")
        Text("IP Address")
      }
      .frame(width: 180, alignment: .leading)
    }
  }
}

private struct ListView: View {
  
  @Environment(SettingsModel.self) private var settings

  @State var selection: UUID?

  private func add(_ radio: SettingsModel.KnownRadio) {
    settings.knownRadios.append(radio)
  }

  private func delete(_ radio: SettingsModel.KnownRadio) {
    settings.knownRadios.remove(at: settings.knownRadios.firstIndex(of: radio)!)
  }

  public var body: some View {
    @Bindable var settingsBindable = settings

    VStack(alignment: .leading) {
      List($settingsBindable.knownRadios, selection: $selection) { $knownRadio in
        HStack {
          Group {
            TextField("Name", text: $knownRadio.name)
            TextField("IP Address", text: $knownRadio.ipAddress)
          }
          .frame(width: 180, alignment: .leading)
        }
      }
      
      Divider()
      
      HStack (spacing: 40) {
        Spacer()
        Button("Add") { add(SettingsModel.KnownRadio("New Radio", "", ""))}
        Button("Delete") {
          for knownRadio in settings.knownRadios where knownRadio.id == selection {
            delete(knownRadio)
          }
        }.disabled(selection == nil)
      }
      Spacer()
    }

  }
}

#Preview {
  ConnectionView()
    .environment(SettingsModel.shared)
    .frame(width: 600, height: 350)
    .padding()
}
