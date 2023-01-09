//
//  Ph2View.swift
//  
//
//  Created by Douglas Adams on 11/15/22.
//

import ComposableArchitecture
import SwiftUI

import Objects

// ----------------------------------------------------------------------------
// MARK: - View

public struct Ph2View: View {
  let store: StoreOf<Ph2Feature>
  
  public init(store: StoreOf<Ph2Feature>) {
    self.store = store
  }
  
  @Dependency(\.apiModel) var apiModel
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      
      VStack(alignment: .leading, spacing: 10) {
        HStack {
          ButtonsView(viewStore: viewStore, transmit: apiModel.transmit)
          SlidersView(viewStore: viewStore, transmit: apiModel.transmit)
        }
        TxFilterView(viewStore: viewStore, transmit: apiModel.transmit)
        MicButtonsView(viewStore: viewStore, transmit: apiModel.transmit)
        Divider().background(.blue)
      }
    }
  }
}

struct ButtonsView: View {
  let viewStore: ViewStore<Ph2Feature.State, Ph2Feature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    VStack(alignment: .leading, spacing: 10) {
      Group {
        Text("AM Carrier")
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.voxEnabled},
          send: { .transmitProperty(.setAndSend, .voxEnabled, $0.as1or0) } )) { Text("VOX").frame(width: 55) }
        Text("Vox Delay")
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.companderEnabled},
          send: { .transmitProperty(.setAndSend, .companderEnabled, $0.as1or0) } )) { Text("DEXP").frame(width: 55) }
      }.toggleStyle(.button)
    }
  }
}

struct SlidersView: View {
  let viewStore: ViewStore<Ph2Feature.State, Ph2Feature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    VStack(spacing: 8) {
      HStack(spacing: 20) {
        Text("\(transmit.carrierLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.carrierLevel) }, send: { .transmitProperty(.setAndSend, .amCarrierLevel, String(Int($0))) }), in: 0...100)
      }
      HStack(spacing: 20) {
        Text("\(transmit.voxLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.voxLevel) }, send: { .transmitProperty(.setAndSend, .voxLevel, String(Int($0))) }), in: 0...100)
      }
      HStack(spacing: 20) {
        Text("\(transmit.voxDelay)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.voxDelay) }, send: { .transmitProperty(.setAndSend, .voxDelay, String(Int($0))) }), in: 0...100)
      }
      HStack(spacing: 20) {
        Text("\(transmit.companderLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.companderLevel) }, send: { .transmitProperty(.setAndSend, .companderLevel, String(Int($0))) }), in: 0...100)
      }
    }
//    .frame(width: 180)
  }
}

struct TxFilterView: View {
  let viewStore: ViewStore<Ph2Feature.State, Ph2Feature.Action>
  @ObservedObject var transmit: Transmit

  enum Focusable: String, Hashable, Equatable {
    case filterLow
    case filterHigh
  }

  @FocusState private var hasFocus: Focusable?

  public var body: some View {
    
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 20) {
        Group {
          Text("Tx Filter")
          HStack(spacing: 2) {
            TextField("", value: viewStore.binding(
              get: {_ in  transmit.txFilterLow},
              send: { .transmitProperty(.set, .txFilterLow, String($0)) } ), format: .number)
            .focused($hasFocus, equals: .filterLow)
            .onSubmit { viewStore.send(.transmitProperty(.send, .txFilterLow, "")) }
            .multilineTextAlignment(.trailing)
            
            Stepper("", value: viewStore.binding(
              get: {_ in  transmit.txFilterLow },
              send: { .transmitProperty(.set, .txFilterLow, String($0)) }),
                    in:  0...transmit.txFilterHigh,
                    step: 50)
            .labelsHidden()
          }

          HStack(spacing: 2) {
            TextField("", value: viewStore.binding(
              get: {_ in  transmit.txFilterHigh},
              send: { .transmitProperty(.set, .txFilterHigh, String($0)) } ), format: .number)
            .focused($hasFocus, equals: .filterHigh)
            .onSubmit { viewStore.send(.transmitProperty(.send, .txFilterHigh, "")) }
            .multilineTextAlignment(.trailing)
            
            Stepper("", value: viewStore.binding(
              get: {_ in  transmit.txFilterHigh },
              send: { .transmitProperty(.set, .txFilterHigh, String($0)) }),
                    in: 0...10_000,
                    step: 50)
            .labelsHidden()
          }
        }
      }.padding(.trailing, 10)
    .onChange(of: hasFocus) { [hasFocus] _ in
//      print("onChange: from \(hasFocus?.rawValue ?? "none") -> \(newValue?.rawValue ?? "none")")
      switch hasFocus {
      case .filterLow:    viewStore.send(.transmitProperty(.send, .txFilterLow, ""))
      case .filterHigh:   viewStore.send(.transmitProperty(.send, .txFilterHigh, ""))
      case .none:         break
      }
    }
    
      HStack(spacing: 65) {
        Group {
          Text("Low Cut")
          Text("High Cut")
        }
        .font(.footnote)
      }
      .padding(.leading, 95)
    }
  }
}

struct MicButtonsView: View {
  let viewStore: ViewStore<Ph2Feature.State, Ph2Feature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    HStack(spacing: 15) {
      Group {
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.micBiasEnabled},
          send: { .transmitProperty(.setAndSend, .micBiasEnabled, $0.as1or0) } )) { Text("Bias").frame(width: 55) }
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.micBoostEnabled},
          send: { .transmitProperty(.setAndSend, .micBoostEnabled, $0.as1or0) } )) { Text("Boost").frame(width: 55) }
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.meterInRxEnabled},
          send: { .transmitProperty(.setAndSend, .meterInRxEnabled, $0.as1or0) } )) { Text("Meter in Rx").frame(width: 70) }
      }
      .toggleStyle(.button)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct Ph2View_Previews: PreviewProvider {
  static var previews: some View {
    Ph2View(store: Store(initialState: Ph2Feature.State(), reducer: Ph2Feature()))
      .frame(width: 275)
  }
}
