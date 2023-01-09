//
//  NetworkSettingsView.swift
//  xMini6001
//
//  Created by Douglas Adams on 5/13/21.
//

import ComposableArchitecture
import SwiftUI

import Objects
import Shared

struct NetworkSettingsView: View {
  let store: StoreOf<NetworkSettingsFeature>
  @ObservedObject var radio: Radio
  
  @Dependency(\.apiModel) var apiModel
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      if apiModel.clientInitialized {
        VStack {
          Spacer()
          Grid(alignment: .leading, horizontalSpacing: 40, verticalSpacing: 20) {
            CurrentAddressView(viewStore: viewStore, radio: radio)
            Spacer()
            Divider().foregroundColor(.blue)
            Spacer()
            StaticAddressView(viewStore: viewStore, radio: radio)
            Spacer()
          }
        }
      } else {
        VStack {
          Text("Radio must be connected").font(.title).foregroundColor(.red)
          Text("to use Network Settings").font(.title).foregroundColor(.red)
        }
      }
    }
  }
}

private struct CurrentAddressView: View {
  let viewStore: ViewStore<NetworkSettingsFeature.State, NetworkSettingsFeature.Action>
  @ObservedObject var radio: Radio
  
  init(viewStore: ViewStore<NetworkSettingsFeature.State, NetworkSettingsFeature.Action>, radio: Radio) {
    self.viewStore = viewStore
    self.radio = radio
  }
  
  private var addressTypes = ["Static", "DHCP"]
  private let width: CGFloat = 140
  
  var body: some View {
    GridRow() {
      Text("Serial number")
      Text(radio.packet?.serial ?? "").foregroundColor(.secondary)
      Text("MAC Address")
      Text(radio.macAddress).foregroundColor(.secondary)
    }
    GridRow() {
      Text("IP Address")
      Text(radio.ipAddress).foregroundColor(.secondary)
      Text("Mask")
      Text(radio.netmask).foregroundColor(.secondary)
    }
    GridRow() {
      Text("Address Type")
      Picker("", selection: viewStore.binding(
        get: {_ in radio.addressType },
        send: { .addressType($0) } )) {
          ForEach(addressTypes, id: \.self) {
            Text($0)
          }
        }
        .labelsHidden()
        .pickerStyle(.menu)
//        .frame(width: width)
      
      Toggle("Enforce Private IP", isOn: viewStore.binding(
        get: {_ in radio.enforcePrivateIpEnabled },
        send: .enforcePrivateIpButton ))
    }
  }
}

private struct StaticAddressView: View {
  let viewStore: ViewStore<NetworkSettingsFeature.State, NetworkSettingsFeature.Action>
  @ObservedObject var radio: Radio

  private let width: CGFloat = 140
  
  var body: some View {
    
    Text("Static Address").font(.title3).foregroundColor(.blue)
    GridRow() {
      Button("Apply") { viewStore.send(.applyStaticButton)}
        .disabled(radio.staticIp.isEmpty || radio.staticMask.isEmpty || radio.staticGateway.isEmpty)
    }
    GridRow() {
      Text("IP Address")
      TextField("", text: viewStore.binding(
        get: {_ in  radio.staticIp },
        send: { .staticIp($0) }))
//      .frame(width: width)
      
      Text("Mask")
      TextField("", text: viewStore.binding(
        get: {_ in  radio.staticMask },
        send: { .staticMask($0) }))
//      .frame(width: width)
      
    }
    GridRow() {
      Text("Gateway")
      TextField("", text: viewStore.binding(
        get: {_ in  radio.staticGateway },
        send: { .staticGateway($0) }))
//      .frame(width: width)
    }
  }
}

struct NetworkSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    NetworkSettingsView(store: Store(initialState: NetworkSettingsFeature.State(), reducer: NetworkSettingsFeature()), radio: Radio(Packet()))
      .frame(width: 600, height: 350)
      .padding()
  }
}
