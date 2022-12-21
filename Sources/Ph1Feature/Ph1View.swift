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
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

public struct Ph1View: View {
  let store: StoreOf<Ph1Feature>
  @ObservedObject var apiModel: ApiModel
  
  public init(store: StoreOf<Ph1Feature>, apiModel: ApiModel) {
    self.store = store
    self.apiModel = apiModel
  }
  
  public var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        VStack(alignment: .leading, spacing: 10) {
          LevelsView()
          ProfileView(viewStore: viewStore, micProfile: apiModel.profiles[id: "mic"] ?? Profile("empty"))
          MicSelectionView(viewStore: viewStore, transmit: apiModel.transmit, radio: apiModel.radio ?? Radio(Packet()))
          ProcView(viewStore: viewStore, transmit: apiModel.transmit, radio: apiModel.radio ?? Radio(Packet()))
          MonView(viewStore: viewStore, transmit: apiModel.transmit, radio: apiModel.radio ?? Radio(Packet()))
        }
        VStack(alignment: .center, spacing: 10) {
          AccView(viewStore: viewStore, transmit: apiModel.transmit, radio: apiModel.radio ?? Radio(Packet()))
          Divider().background(.blue)
        }
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
        .frame(width: 70, alignment: .leading)
      
      HStack(spacing: 20) {
        Text("\(transmit.micLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.micLevel) }, send: { .micLevelSlider( Int($0)) }), in: 0...100)
      }
    }
  }
}

private struct ProcView: View {
  let viewStore: ViewStore<Ph1Feature.State, Ph1Feature.Action>
  @ObservedObject var transmit: Transmit
  @ObservedObject var radio: Radio
  
  public var body: some View {
    VStack(spacing: 0) {
      
      HStack(spacing: 40) {
        Text("NOR")
        Text("DX")
        Text("DX+")
      }
      .padding(.leading, 125)
      .font(.footnote)
      
      HStack(spacing: 10) {
        Toggle(isOn: viewStore.binding(
          get: {_ in  transmit.speechProcessorEnabled },
          send: { .speechProcessorButton($0) })) { Text("PROC").frame(width: 55)}
          .toggleStyle(.button)
        
        HStack(spacing: 20) {
          Text("\(transmit.speechProcessorLevel)").frame(width: 25, alignment: .trailing)
          Slider(value: viewStore.binding(get: {_ in Double(transmit.speechProcessorLevel) }, send: { .speechProcessorLevelSlider( Int($0)) }), in: 0...100)
        }
      }
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
        send: { .txMonitorButton($0) })) { Text("MON").frame(width: 55)}
        .toggleStyle(.button)
      
      HStack(spacing: 20) {
        Text("\(transmit.ssbMonitorGain)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.ssbMonitorGain) }, send: { .ssbMonitorGainSlider( Int($0)) }), in: 0...100)
      }
    }
  }
}

private struct AccView: View {
  let viewStore: ViewStore<Ph1Feature.State, Ph1Feature.Action>
  @ObservedObject var transmit: Transmit
  @ObservedObject var radio: Radio
  
  public var body: some View {
    
    HStack(alignment: .center, spacing: 40) {
      Toggle(isOn: viewStore.binding(
        get: {_ in  transmit.micAccEnabled },
        send: { .micAccButton($0) })) { Text("ACC").frame(width: 40)}
        .toggleStyle(.button)
      
      Toggle(isOn: viewStore.binding(
        get: {_ in  transmit.daxEnabled },
        send: { .daxButton($0) })) { Text("DAX").frame(width: 40)}
        .toggleStyle(.button)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct Ph1View_Previews: PreviewProvider {
    static var previews: some View {
      Ph1View(store: Store(initialState: Ph1Feature.State(), reducer: Ph1Feature()), apiModel: ApiModel())
        .frame(width: 275, height: 250)
        .previewDisplayName("Ph1")
    }
}
