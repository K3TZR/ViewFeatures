//
//  CwView.swift
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

public struct CwView: View {
  let store: StoreOf<CwFeature>
  
  @Dependency(\.apiModel) var apiModel
  
  public init(store: StoreOf<CwFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 10)  {
        LevelIndicatorView(level: 0.25, type: .alc)
          .padding(.bottom, 10)
        
        HStack {
          ButtonsView(viewStore: viewStore, transmit: apiModel.transmit)
          SlidersView(viewStore: viewStore, transmit: apiModel.transmit)
        }
        BottomButtonsView(viewStore: viewStore, transmit: apiModel.transmit)
        Divider().background(.blue)
      }
//      .frame(width: 275)
    }
  }
}

struct ButtonsView: View {
  let viewStore: ViewStore<CwFeature.State, CwFeature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    VStack(alignment: .leading, spacing: 13){
      Group {
        Text("Delay")
        Text("Speed")
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.cwSidetoneEnabled },
          send: { .transmitProperty(.setAndSend, .cwSidetoneEnabled, String($0)) } )) {Text("Sidetone").frame(width: 55)}
          .toggleStyle(.button)
        Text("Pan")
      }
    }
  }
}

struct SlidersView: View {
  let viewStore: ViewStore<CwFeature.State, CwFeature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    VStack(spacing: 8) {
      HStack(spacing: 10) {
        Text("\(transmit.cwBreakInDelay)").frame(width: 35, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.cwBreakInDelay) }, send: { .transmitProperty(.setAndSend, .cwBreakInDelay, String($0)) }), in: 30...2_000)
      }
      HStack(spacing: 20) {
        Text("\(transmit.cwSpeed)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.cwSpeed) }, send: { .transmitProperty(.setAndSend, .cwSpeed, String($0)) }), in: 0...100)
      }
      HStack(spacing: 20) {
        Text("\(transmit.cwMonitorGain)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.cwMonitorGain) }, send: { .transmitProperty(.setAndSend, .cwMonitorGain, String($0)) }), in: 0...100)
      }
      HStack(spacing: 20) {
        Text("\(transmit.cwMonitorPan)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.cwMonitorPan) }, send: { .transmitProperty(.setAndSend, .cwMonitorPan, String($0)) }), in: 0...100)
      }
    }
//    .frame(width: 180)
  }
}

struct BottomButtonsView: View {
  let viewStore: ViewStore<CwFeature.State, CwFeature.Action>
  @ObservedObject var transmit: Transmit
  
  enum Focusable: String, Hashable, Equatable {
    case pitch
  }
  
  @FocusState private var hasFocus: Focusable?
  
  public var body: some View {
    
    HStack(spacing: 10) {
      Group {
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.cwBreakInEnabled },
          send: { .transmitProperty(.setAndSend, .cwBreakInEnabled, String($0)) } )) {Text("BreakIn").frame(width: 55)}
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.cwIambicEnabled },
          send: { .transmitProperty(.setAndSend, .cwIambicEnabled, String($0)) } )){Text("Iambic").frame(width: 45)}
      }
      .toggleStyle(.button)
      
      Text("Pitch")
      TextField("", value: viewStore.binding(
        get: {_ in  transmit.cwPitch},
        send: { .transmitProperty(.set, .cwPitch, String($0)) } ), format: .number)
      .focused($hasFocus, equals: .pitch)
      .onSubmit { viewStore.send(.transmitProperty(.send, .cwPitch, "")) }
      .multilineTextAlignment(.trailing)
      
      Stepper("", value: viewStore.binding(
        get: {_ in  transmit.cwPitch },
        send: { .transmitProperty(.setAndSend, .cwPitch, String($0)) } ),
              in: 100...6000,
              step: 50)
      .labelsHidden()
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct CwView_Previews: PreviewProvider {
  static var previews: some View {
    CwView(store: Store(initialState: CwFeature.State(), reducer: CwFeature()))
      .frame(width: 275, height: 210)
  }
}
