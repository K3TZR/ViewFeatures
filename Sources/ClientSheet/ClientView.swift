//
//  ClientFeature.swift
//  ViewFeatures/ClientFeature
//
//  Created by Douglas Adams on 1/19/22.
//

import SwiftUI

import SharedModel

// ----------------------------------------------------------------------------
// MARK: - View(s)

// assumes that the number of GuiClients is 1 or 2

public struct ClientView: View {
  var packet: Binding<Packet?>
  var heading: String
  var choice: Binding<UInt32?>

  public init
  (
    packet: Binding<Packet?>,
    heading: String = "Choose an action",
    choice: Binding<UInt32?>
  )
  {
    self.packet = packet
    self.heading = heading
    self.choice = choice
  }

  @Environment(\.dismiss) var dismiss

  public var body: some View {
    VStack(spacing: 20) {
      Text(heading).font(.title)
      Divider().background(Color.blue)
      
      if packet.wrappedValue?.guiClients.count == 1 {
        Button( action: { choice.wrappedValue = nil ; dismiss() })
        { Text("MultiFlex connect").frame(width: 150) }

        Button( action: { choice.wrappedValue = packet.wrappedValue!.guiClients[0].handle ; dismiss() })
        { Text("Close " + packet.wrappedValue!.guiClients[0].station).frame(width: 150) }
      }
      
      if packet.wrappedValue?.guiClients.count == 2 {
        Button( action: { choice.wrappedValue = packet.wrappedValue!.guiClients[0].handle  ; dismiss() })
        { Text("Close " + packet.wrappedValue!.guiClients[0].station).frame(width: 150) }

        Button( action: { choice.wrappedValue = packet.wrappedValue!.guiClients[1].handle  ; dismiss() })
        { Text("Close " + packet.wrappedValue!.guiClients[1].station).frame(width: 150) }
      }
      
      Divider().background(Color.blue)
      Button( action: { packet.wrappedValue = nil ; choice.wrappedValue = nil ; dismiss() })
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
  ClientView(packet: .constant(Packet()),
             choice: .constant(UInt32?(nil)))
}

#Preview("Gui connect (disconnect required)") {
  ClientView(packet: .constant(Packet()),
             choice: .constant(UInt32?(nil)))
}
