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
  var selection: Binding<Packet?>
  var defaultMethod: (Packet) -> Void
  var testMethod: (Packet) -> Bool
  
  @Environment(Listener.self) private var listener
  @Environment(SettingsModel.self) var settings
  
  public init(
    selection: Binding<Packet?>,
    defaultMethod: @escaping (Packet) -> Void,
    testMethod: @escaping (Packet) -> Bool
  )
  {
    self.selection = selection
    self.defaultMethod = defaultMethod
    self.testMethod = testMethod
  }
  
  @State var pickerSelection: Packet? = nil
  @State var testResult: Bool = false
  
  private func isDefault(_ packet: Packet) -> Bool {
    settings.guiDefault?.serial == packet.serial && settings.guiDefault?.source == packet.source.rawValue
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      HeaderView()
      
      Divider()
      if listener.packets.count == 0 {
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
        
        List(listener.packets, id: \.self, selection: $pickerSelection) { packet in
          HStack(spacing: 0) {
            Group {
              Text(packet.nickname)
              Text(packet.source.rawValue)
              Text(packet.status)
              Text(packet.guiClients.reduce("") {$0 + $1.station + " "})
            }
            .font(.title3)
            .foregroundColor(isDefault(packet) ? .red : nil)
            .frame(minWidth: 140, alignment: .leading)
          }
        }
        .frame(minHeight: 150)
        .padding(.horizontal)
      }
      
      Divider()
      FooterView(selection: selection, pickerSelection: pickerSelection, defaultMethod: defaultMethod, testMethod: testMethod)
    }
  }
}

private struct HeaderView: View {
  
  var body: some View {
    VStack {
      Text("Select a RADIO")
        .font(.title)
        .padding(.bottom, 10)
      
      HStack(spacing: 0) {
        Group {
          Text("Name")
          Text("Type")
          Text("Status")
          Text("Station(s)")
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
  let selection: Binding<Packet?>
  let pickerSelection: Packet?
  let defaultMethod: (Packet) -> Void
  let testMethod: (Packet) -> Bool
  
  @Environment(\.dismiss) var dismiss

  @Environment(Listener.self) private var listener

  @State var testResult = false
  
  var body: some View {
    
    HStack(){
      Button("Test") {
        listener.smartlinkTestResult = SmartlinkTestResult()
        listener.smartlinkTest(pickerSelection!.serial)
      }
        .disabled(pickerSelection == nil || pickerSelection?.source != .smartlink )
      Circle()
        .fill(listener.smartlinkTestResult.success ? Color.green : Color.red)
        .frame(width: 20, height: 20)
      
      Spacer()
      Button("Default") {
        defaultMethod(pickerSelection!)
      }
      .disabled(pickerSelection == nil)
      .keyboardShortcut(.cancelAction)
      
      Spacer()
      Button("Cancel") {
        selection.wrappedValue = nil
        dismiss()
      }
      .keyboardShortcut(.cancelAction)
      
      Spacer()
      Button("Connect") {
        selection.wrappedValue = pickerSelection
        dismiss()
      }
      .keyboardShortcut(.defaultAction)
      .disabled(pickerSelection == nil)
    }
    .padding(.vertical, 10)
    .padding(.horizontal)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

#Preview("Picker Gui") {
  PickerView(selection: .constant(Packet?(nil)), defaultMethod: {_ in}, testMethod: {_ in true})
    .environment(Listener.shared)
    .environment(SettingsModel.shared)
}
