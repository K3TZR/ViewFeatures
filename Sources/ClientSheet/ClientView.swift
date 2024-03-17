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
  var guiClients: IdentifiedArrayOf<GuiClient>
  var handleToDisconnect: Binding<UInt32?>
  var pickerSelection: Binding<String?>

  public init
  (
    heading: String = "Choose an action",
    guiClients: IdentifiedArrayOf<GuiClient>,
    handleToDisconnect: Binding<UInt32?>,
    pickerSelection: Binding<String?>
  )
  {
    self.heading = heading
    self.guiClients = guiClients
    self.handleToDisconnect = handleToDisconnect
    self.pickerSelection = pickerSelection
  }

  @Environment(\.dismiss) var dismiss

  public var body: some View {
    VStack(spacing: 20) {
      Text(heading).font(.title)
      Divider().background(Color.blue)
      
      if guiClients.count == 1 {
        Button( action: { handleToDisconnect.wrappedValue = nil ; dismiss() })
        { Text("MultiFlex connect").frame(width: 150) }
      }
      
      ForEach(guiClients) { guiClient in
        Button( action: { handleToDisconnect.wrappedValue = guiClient.handle ; dismiss() })
        { Text("Close " + guiClient.station).frame(width: 150) }
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

//#Preview("Gui connect (disconnect not required)") {
//  ClientView(guiClients: GuiClient(handle: 1),
//             handleToDisconnect: .constant(UInt32?(nil)),
//             pickerSelection: .constant(String?(nil)))
//}
//
//#Preview("Gui connect (disconnect required)") {
//  ClientView(guiClients: [GuiClient(handle: 1), GuiClient(handle: 2)]
//             handleToDisconnect: .constant(UInt32?(nil)),
//             pickerSelection: .constant(String?(nil)))
//}
