//
//  TxView.swift
//
//
//  Created by Douglas Adams on 11/15/22.
//

import ComposableArchitecture
import SwiftUI

import LevelIndicatorView
import Objects
import Shared

public struct TxView: View {
  let store: StoreOf<TxFeature>
  
  public init(store: StoreOf<TxFeature>) {
    self.store = store
  }
  
  @Dependency(\.apiModel) var apiModel
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(spacing: 10) {
        VStack(alignment: .leading, spacing: 10)  {
          LevelsView()
          PowerView(viewStore: viewStore, transmit: apiModel.transmit)
          ProfileView(viewStore: viewStore, txProfile: apiModel.profiles[id: "tx"] ?? Profile("empty"), atu: apiModel.atu)
          AtuStatusView(viewStore: viewStore, atu: apiModel.atu)
        }
        VStack(alignment: .center, spacing: 10) {
          ButtonsView(viewStore: viewStore, transmit: apiModel.transmit, radio: apiModel.radio ?? Radio(Packet()), atu: apiModel.atu)
          Divider().background(.blue)
        }
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
  let viewStore: ViewStore<TxFeature.State, TxFeature.Action>
  @ObservedObject var transmit: Transmit

  public var body: some View {

    VStack(spacing: 5) {
      HStack(spacing: 10) {
        Text("Rf Power").frame(width: 75, alignment: .leading)
        HStack(spacing: 20) {
          Text("\(transmit.rfPower)").frame(width: 25, alignment: .trailing)
          Slider(value: viewStore.binding(get: {_ in Double(transmit.rfPower) }, send: { .rfPowerSlider( Int($0)) }), in: 0...100)
        }
      }
      HStack(spacing: 10) {
        Text("Tune Power").frame(width: 75, alignment: .leading)
        HStack(spacing: 20) {
          Text("\(transmit.tunePower)").frame(width: 25, alignment: .trailing)
          Slider(value: viewStore.binding(get: {_ in Double(transmit.tunePower) }, send: { .tunePowerSlider( Int($0)) }), in: 0...100)
        }
      }
    }
  }
}

private struct ProfileView: View {
  let viewStore: ViewStore<TxFeature.State, TxFeature.Action>
  @ObservedObject var txProfile: Profile
  @ObservedObject var atu: Atu

  public var body: some View {
    HStack(spacing: 25) {
      Picker("", selection: viewStore.binding(
        get: {_ in  txProfile.current.id },
        send: { .txProfilePicker($0) })) {
        ForEach(txProfile.list) {
          Text($0.name).tag($0.id)
        }
      }
      .labelsHidden()
      .pickerStyle(.menu)
      .frame(width: 210, alignment: .leading)
      
      Button("Save", action: {})
        .font(.footnote)
        .buttonStyle(BorderlessButtonStyle())
        .foregroundColor(.blue)
    }
  }
}

private struct AtuStatusView: View {
  let viewStore: ViewStore<TxFeature.State, TxFeature.Action>
  @ObservedObject var atu: Atu
  
  public var body: some View {
    HStack(spacing: 20) {
      Button(action: { viewStore.send(.atuButton) })
      { Text("ATU").frame(width: 40) }.background(atu.enabled ? Color(.controlAccentColor) : Color(.controlBackgroundColor))
        .disabled(atu.enabled == false)
      
      Text(atu.status.rawValue).frame(width: 180)
        .border(.secondary)
    }
  }
}

private struct ButtonsView: View {
  let viewStore: ViewStore<TxFeature.State, TxFeature.Action>
  @ObservedObject var transmit: Transmit
  @ObservedObject var radio: Radio
  @ObservedObject var atu: Atu

  public var body: some View {
    HStack(spacing: 45) {
      Group {
        Toggle(isOn: viewStore.binding(
          get: {_ in atu.memoriesEnabled},
          send: { .memoriesEnabledButton($0) })) { Text("MEM").frame(width: 40) }
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.tune},
          send: { .tuneButton($0) } )) { Text("TUNE").frame(width: 40) }
        Toggle(isOn: viewStore.binding(
          get: {_ in radio.mox},
          send: { .moxButton($0) } )) { Text("MOX").frame(width: 40) }
      }
      .toggleStyle(.button)
    }
  }
}

struct TxView_Previews: PreviewProvider {
    static var previews: some View {
      TxView(store: Store(initialState: TxFeature.State(), reducer: TxFeature()))
        .frame(width: 275)
    }
}
