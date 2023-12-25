//
//  ClientFeature.swift
//  ViewFeatures/ClientFeature
//
//  Created by Douglas Adams on 1/19/22.
//

import IdentifiedCollections
import SwiftUI

import SharedModel

// ----------------------------------------------------------------------------
// MARK: - View(s)

// assumes that the number of GuiClients is 1 or 2

public struct ClientView: View {
  var heading: String
  var stations: IdentifiedArrayOf<Station>
  var idToDisconnect: Binding<String?>
  var pickerSelection: Binding<String?>

  public init
  (
    heading: String = "Choose an action",
    stations: IdentifiedArrayOf<Station>,
    idToDisconnect: Binding<String?>,
    pickerSelection: Binding<String?>
  )
  {
    self.heading = heading
    self.stations = stations
    self.idToDisconnect = idToDisconnect
    self.pickerSelection = pickerSelection
  }

  @Environment(\.dismiss) var dismiss

  public var body: some View {
    VStack(spacing: 20) {
      Text(heading).font(.title)
      Divider().background(Color.blue)
      
      if stations.count == 1 {
        Button( action: { idToDisconnect.wrappedValue = nil ; dismiss() })
        { Text("MultiFlex connect").frame(width: 150) }
      }
      
      ForEach(stations) { item in
        Button( action: { idToDisconnect.wrappedValue = item.packet.id ; dismiss() })
        { Text("Close " + item.station).frame(width: 150) }
      }
              
      Divider().background(Color.blue)
      Button( action: { pickerSelection.wrappedValue = nil ; dismiss() })
      { Text("Cancel") }
        .keyboardShortcut(.cancelAction)
    }
    .frame(width: 250)
    .padding()
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview(s)

#Preview("Gui connect (disconnect not required)") {
  ClientView(stations: [Station(packet: Packet(), station: "K3TZR")], 
             idToDisconnect: .constant(String?(nil)),
             pickerSelection: .constant(String?(nil)))
}

#Preview("Gui connect (disconnect required)") {
  ClientView(stations: [Station(packet: Packet(), station: "K3TZS"), Station(packet: Packet(), station: "N4CEC")],
             idToDisconnect: .constant(String?(nil)),
             pickerSelection: .constant(String?(nil)))
}
