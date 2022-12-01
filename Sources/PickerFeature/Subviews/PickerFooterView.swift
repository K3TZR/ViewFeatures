//
//  PickerFooterView.swift
//
//  Created by Douglas Adams on 1/9/22.
//

import SwiftUI
import ComposableArchitecture

import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct PickerFooterView: View {
  let store: StoreOf<PickerFeature>
  
  var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(){
        Button("Test") { viewStore.send(.testButton(viewStore.selection!)) }
          .disabled(viewStore.selection == nil || viewStore.selection!.packet.source == PacketSource.local)
        Circle()
          .fill(viewStore.testResult ? Color.green : Color.red)
          .frame(width: 20, height: 20)
        
        Spacer()
        Button("Default") { viewStore.send(.defaultButton(viewStore.selection!)) }
          .disabled(viewStore.selection == nil)
          .keyboardShortcut(.cancelAction)
        
        Spacer()
        Button("Cancel") { viewStore.send(.cancelButton) }
          .keyboardShortcut(.cancelAction)
        
        Spacer()
        Button("Connect") {
          viewStore.send(.connectButton(viewStore.selection!)) }
          .keyboardShortcut(.defaultAction)
          .disabled(viewStore.selection == nil)
      }
    }
    .padding(.vertical, 10)
    .padding(.horizontal)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

//struct PickerFooterView_Previews: PreviewProvider {
//  static var previews: some View {
//
//    PickerFooterView(store: Store(initialState:
//                                    PickerState(pickables: IdentifiedArrayOf<Pickable>(),
//                                                isGui: true,
////                                                defaultId: nil,
//                                                selection: nil,
//                                                testResult: false),
//                                  reducer: pickerReducer,
//                                  environment: PickerEnvironment())
//    )
//  }
//}




//    PickerFooterView(store: Store(
//      initialState: PickerState(connectionType: .nonGui, testResult: testResultSuccess1, discovery: LanDiscovery()),
//      reducer: pickerReducer,
//      environment: PickerEnvironment() )
//    )
//      .previewDisplayName("Test true (FORWARDING)")
//
//    PickerFooterView(store: Store(
//      initialState: PickerState(connectionType: .nonGui, testResult: testResultSuccess2, discovery: LanDiscovery()),
//      reducer: pickerReducer,
//      environment: PickerEnvironment() )
//    )
//      .previewDisplayName("Test true (UPNP)")
//  }
//}
//
//
//var testResultFail: SmartlinkTestResult {
//  SmartlinkTestResult()
//}
//
//var testResultSuccess1: SmartlinkTestResult {
//  var result = SmartlinkTestResult()
//  result.forwardTcpPortWorking = true
//  result.forwardUdpPortWorking = true
//  return result
//}
//
//var testResultSuccess2: SmartlinkTestResult {
//  var result = SmartlinkTestResult()
//  result.upnpTcpPortWorking = true
//  result.upnpUdpPortWorking = true
//  return result
//}
