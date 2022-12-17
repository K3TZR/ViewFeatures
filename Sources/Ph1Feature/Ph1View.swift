//
//  Ph1View.swift
//  
//
//  Created by Douglas Adams on 11/15/22.
//

import ComposableArchitecture
import SwiftUI

import LevelIndicatorView
import Objects

// ----------------------------------------------------------------------------
// MARK: - View

public struct Ph1View: View {
  let store: StoreOf<Ph1Feature>

  public init(store: StoreOf<Ph1Feature>) {
    self.store = store
  }

  @Dependency(\.apiModel) var apiModel
  
  public var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 20) {
        LevelsView()
        ProfileView(viewStore: viewStore, micProfile: apiModel.profiles[id: "mic"]!)
        MicSelectionView(viewStore: viewStore, transmit: apiModel.transmit, radio: apiModel.radio!)
        ProcView(viewStore: viewStore, transmit: apiModel.transmit, radio: apiModel.radio!)
        MonView(viewStore: viewStore, transmit: apiModel.transmit, radio: apiModel.radio!)
        Divider().background(.blue)
      }
    }
  }
}

private struct LevelsView: View {
  
  public var body: some View {
    VStack(alignment: .center, spacing: 5)  {
      LevelIndicatorView(level: -20.0, type: .micLevel)
      LevelIndicatorView(level: -15.0, type: .compression)
    }
  }
}

private struct ProfileView: View {
  let viewStore: ViewStore<Ph1Feature.State, Ph1Feature.Action>
  @ObservedObject var micProfile: Profile
  
  public var body: some View {
    HStack(spacing: 25) {
      Picker("", selection: viewStore.binding(
        get: {_ in  micProfile.current },
        send: { .micProfilePicker($0) })) {
        ForEach(micProfile.list, id: \.self) {
          Text($0)
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

private struct MicSelectionView: View {
  let viewStore: ViewStore<Ph1Feature.State, Ph1Feature.Action>
  @ObservedObject var transmit: Transmit
  @ObservedObject var radio: Radio

  public var body: some View {

    VStack {
      HStack(spacing: 10) {
        Picker("", selection: viewStore.binding(
          get: {_ in  transmit.micSelection },
          send: { .micSelectionPicker($0) })) {
            ForEach(radio.micList, id: \.self) {
              Text($0)
            }
          }
          .labelsHidden()
          .pickerStyle(.menu)
          .frame(width: 60, alignment: .leading)
        
        Slider(value: viewStore.binding(
          get: {_ in  Double(transmit.micLevel) },
          send: { .micLevelSlider(Int($0)) }), in: -1...1)
        
        Toggle(isOn: viewStore.binding(
          get: {_ in  transmit.micAccEnabled },
          send: { .micAccButton($0) })) { Text("ACC").frame(width: 30)}
        .toggleStyle(.button)
      }
      
      HStack(spacing: 35) {
        Text("NOR")
        Text("DX")
        Text("DX+")
      }.font(.footnote)
    }
  }
}

private struct ProcView: View {
  let viewStore: ViewStore<Ph1Feature.State, Ph1Feature.Action>
  @ObservedObject var transmit: Transmit
  @ObservedObject var radio: Radio
  
  public var body: some View {
    
    HStack(spacing: 10) {
      Toggle(isOn: viewStore.binding(
        get: {_ in  transmit.speechProcessorEnabled },
        send: { .speechProcessorButton($0) })) { Text("PROC").frame(width: 40)}
      .toggleStyle(.button)

      Slider(value: viewStore.binding(
        get: {_ in  Double(transmit.speechProcessorLevel) },
        send: { .speechProcessorLevelSlider(Int($0)) }), in: -1...1)
      
      Toggle(isOn: viewStore.binding(
        get: {_ in  transmit.daxEnabled },
        send: { .daxButton($0) })) { Text("DAX").frame(width: 30)}
      .toggleStyle(.button)
    }
  }
}

private struct MonView: View {
  let viewStore: ViewStore<Ph1Feature.State, Ph1Feature.Action>
  @ObservedObject var transmit: Transmit
  @ObservedObject var radio: Radio
  
  public var body: some View {
    
    HStack(spacing: 10) {
      Toggle(isOn: viewStore.binding(
        get: {_ in  transmit.txMonitorEnabled },
        send: { .txMonitorButton($0) })) { Text("Mon").frame(width: 40)}
      .toggleStyle(.button)

      Slider(value: viewStore.binding(
        get: {_ in  Double(transmit.ssbMonitorGain) },
        send: { .ssbMonitorGainSlider(Int($0)) }), in: -1...1)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct Ph1View_Previews: PreviewProvider {
    static var previews: some View {
      Ph1View(store: Store(initialState: Ph1Feature.State(), reducer: Ph1Feature()))
        .frame(width: 275, height: 250)
        .previewDisplayName("Ph1")
    }
}
