//
//  RxView.swift
//  
//
//  Created by Douglas Adams on 11/15/22.
//

import ComposableArchitecture
import SwiftUI

import LevelIndicatorView
import Objects
import Shared

public struct RxView: View {
  let store: StoreOf<RxFeature>
  
  public init(store: StoreOf<RxFeature>) {
    self.store = store
  }
  
  @Dependency(\.apiModel) var apiModel
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .center, spacing: 10)  {
        LevelsView()
        PowerView(viewStore: viewStore, transmit: apiModel.transmit)
        ProfileView(viewStore: viewStore, txProfile: apiModel.profiles[id: "tx"] ?? Profile("empty"), atu: apiModel.atu)
        ButtonsView(viewStore: viewStore, transmit: apiModel.transmit, radio: apiModel.radio ?? Radio(Packet()), atu: apiModel.atu)
        Divider().background(.blue)
      }
    }
  }
}

private struct LevelsView: View {
  
  public var body: some View {
    VStack(alignment: .center, spacing: 5)  {
      LevelIndicatorView(level: 75, type: .rfPower)
      LevelIndicatorView(level: 1.5, type: .swr)
    }
  }
}

private struct PowerView: View {
  let viewStore: ViewStore<RxFeature.State, RxFeature.Action>
  @ObservedObject var transmit: Transmit

  public var body: some View {
    VStack {
      HStack {
        Text("RF Power").frame(width: 80, alignment: .leading)
        Text("\(transmit.rfPower, specifier: "%.0f")").frame(width: 25, alignment: .trailing)
        Spacer()
        Slider(value: viewStore.binding(
          get: {_ in  Double(transmit.rfPower) },
          send: { .rfPowerSlider(Int($0)) }), in: 0...100)
      }
      HStack {
        Text("Tune Power").frame(width: 80, alignment: .leading)
        Text("\(transmit.tunePower, specifier: "%.0f")").frame(width: 25, alignment: .trailing)
        Spacer()
        Slider(value: viewStore.binding(
          get: {_ in  Double(transmit.tunePower) },
          send: { .tunePowerSlider(Int($0)) }), in: 0...100)
      }
    }
  }
}

private struct ProfileView: View {
  let viewStore: ViewStore<RxFeature.State, RxFeature.Action>
  @ObservedObject var txProfile: Profile
  @ObservedObject var atu: Atu

  public var body: some View {
    HStack(spacing: 20) {
      Picker("", selection: viewStore.binding(
        get: {_ in  txProfile.current },
        send: { .txProfilePicker($0) })) {
          ForEach(txProfile.list, id: \.self) {
          Text($0).tag($0)
        }
      }
      .labelsHidden()
      .pickerStyle(.menu)
      .frame(width: 100, alignment: .leading)

      Button("Save", action: {})
        .font(.footnote)
        .buttonStyle(BorderlessButtonStyle())
        .foregroundColor(.blue)
      
      Text(atu.status.rawValue).frame(width: 110)
        .border(.secondary)
    }
  }
}

private struct ButtonsView: View {
  let viewStore: ViewStore<RxFeature.State, RxFeature.Action>
  @ObservedObject var transmit: Transmit
  @ObservedObject var radio: Radio
  @ObservedObject var atu: Atu

  public var body: some View {
    HStack(spacing: 25) {
      Group {
        Toggle("TUNE", isOn: viewStore.binding(
          get: {_ in transmit.tune},
          send: .tuneButton ))
        Toggle("MOX", isOn: viewStore.binding(
          get: {_ in radio.mox},
          send: .moxButton ))
        Toggle("ATU", isOn: viewStore.binding(
          get: {_ in atu.enabled},
          send: .atuEnabledButton ))
        Toggle("MEM", isOn: viewStore.binding(
          get: {_ in atu.memoriesEnabled},
          send: .memoriesEnabledButton ))
      }
      .toggleStyle(.button)
    }
  }
}

struct RxView_Previews: PreviewProvider {
    static var previews: some View {
      RxView(store: Store(initialState: RxFeature.State(), reducer: RxFeature()))
        .frame(width: 275)
    }
}
