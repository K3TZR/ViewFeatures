//
//  PickerView.swift
//  ViewFeatures/PickerFeature
//
//  Created by Douglas Adams on 11/13/21.
//

import IdentifiedCollections
import SwiftUI

import Listener
import SettingsModel
import SharedModel

// ----------------------------------------------------------------------------
// MARK: - View(s)

public struct PickerView: View {
  var selection: Binding<String?>
  var defaultMethod: (String) -> Void
  var testMethod: (String) -> Bool
  
  @Environment(Listener.self) private var listener
  @Environment(SettingsModel.self) var settings
  
  public init(
    selection: Binding<String?>,
    defaultMethod: @escaping (String) -> Void,
    testMethod: @escaping (String) -> Bool
  )
  {
    self.selection = selection
    self.defaultMethod = defaultMethod
    self.testMethod = testMethod
  }
  
//  @State var selection: String? = nil
  @State var testResult: Bool = false
  
  private func isDefaultPacket(_ packet: Packet) -> Bool {
    settings.guiDefault?.serial == packet.serial &&
    settings.guiDefault?.source == packet.source.rawValue
  }
  private func isDefaultStation(_ station: Station) -> Bool {
    settings.nonGuiDefault?.serial == station.packet.serial &&
    settings.nonGuiDefault?.source == station.packet.source.rawValue &&
    settings.nonGuiDefault?.station == station.station
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      HeaderView()
      
      Divider()
      if settings.isGui && listener.packets.count == 0 || !settings.isGui && listener.stations.count == 0 {
        VStack {
          HStack {
            Spacer()
            Text("----------  NO \(settings.isGui ? "RADIOS" : "STATIONS") FOUND  ----------")
            Spacer()
          }
          if !settings.localEnabled && !settings.smartlinkEnabled {
            HStack {
              Spacer()
              Text("at least one source (Local or Smartlink) must be selected")
              Spacer()
            }
          }
        }
        .foregroundColor(.red)
        .frame(minHeight: 150)
        .padding(.horizontal)
        
      } else {
        if settings.isGui {
          // ----- List of Radios -----
          List(listener.packets, id: \.id, selection: selection) { packet in
            //            VStack (alignment: .leading) {
            HStack(spacing: 0) {
              Group {
                Text(packet.nickname)
                Text(packet.source.rawValue)
                Text(packet.status)
                Text(packet.guiClientStations)
              }
              .font(.title3)
              .foregroundColor(isDefaultPacket(packet) ? .red : nil)
              .frame(minWidth: 140, alignment: .leading)
            }
            //            }
          }
          .frame(minHeight: 150)
          .padding(.horizontal)
          
        } else {
          // ----- List of Stations -----
          List(listener.stations, id: \.id, selection: selection) { station in
            //            VStack (alignment: .leading) {
            HStack(spacing: 0) {
              Group {
                Text(station.packet.nickname)
                Text(station.packet.source.rawValue)
                Text(station.packet.status)
                Text(station.station)
              }
              .font(.title3)
              .foregroundColor(isDefaultStation(station) ? .red : nil)
              .frame(minWidth: 140, alignment: .leading)
            }
            //            }
          }
          .frame(minHeight: 150)
          .padding(.horizontal)
        }
      }
    }
    Divider()
    FooterView(selection: selection,
               defaultMethod: defaultMethod,
               testMethod: testMethod)
  }
}

private struct HeaderView: View {
  
  @Environment(SettingsModel.self) var settings
  
  var body: some View {
    VStack {
      Text("Select a \(settings.isGui ? "RADIO" : "STATION")")
        .font(.title)
        .padding(.bottom, 10)
      
      HStack(spacing: 0) {
        Group {
          Text("Name")
          Text("Type")
          Text("Status")
          Text("Station\(settings.isGui ? "s" : "")")
        }
        .frame(width: 140, alignment: .leading)
      }
    }
    .font(.title2)
    .padding(.vertical, 10)
    .padding(.horizontal)
  }
}

private struct FooterView: View {
  let selection: Binding<String?>
  let defaultMethod: (String) -> Void
  let testMethod: (String) -> Bool
  
  @Environment(\.dismiss) var dismiss
  
  @Environment(Listener.self) private var listener
  @Environment(SettingsModel.self) private var settings
  
  @State var testResult = false
  
  var body: some View {
    
    HStack(){
      Button("Test") {
        listener.smartlinkTestResult = SmartlinkTestResult()
//        listener.smartlinkTest(packetSelection!.serial)
      }
      //      .disabled(selected == nil)
      Circle()
        .fill(listener.smartlinkTestResult.success ? Color.green : Color.red)
        .frame(width: 20, height: 20)
      
      Spacer()
      Button("Default") {
        defaultMethod(selection.wrappedValue!)
      }
      .disabled(selection.wrappedValue == nil)
      .keyboardShortcut(.cancelAction)
      
      Spacer()
      Button("Cancel") {
        selection.wrappedValue = nil
        dismiss()
      }
      .keyboardShortcut(.cancelAction)
      
      Spacer()
      Button("Connect") {
        dismiss()
      }
      .keyboardShortcut(.defaultAction)
      .disabled(selection.wrappedValue == nil)
    }
    .padding(.vertical, 10)
    .padding(.horizontal)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

#Preview("Picker Gui") {
  PickerView(selection: .constant(String?(nil)), defaultMethod: {_ in}, testMethod: {_ in true})
    .environment(Listener.shared)
    .environment(SettingsModel.shared)
}
