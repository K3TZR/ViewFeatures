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
          send: .voxButton )) { Text("VOX").frame(width: 55) }
        Text("Vox Delay")
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.companderEnabled},
          send: .dexpButton )) { Text("DEXP").frame(width: 55) }
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
        Slider(value: viewStore.binding(get: {_ in Double(transmit.carrierLevel) }, send: { .levelSlider(.amCarrierLevel, Int($0)) }), in: 0...100)
      }
      HStack(spacing: 20) {
        Text("\(transmit.voxLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.voxLevel) }, send: { .levelSlider(.voxLevel, Int($0)) }), in: 0...100)
      }
      HStack(spacing: 20) {
        Text("\(transmit.voxDelay)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.voxDelay) }, send: { .levelSlider(.voxDelay, Int($0)) }), in: 0...100)
      }
      HStack(spacing: 20) {
        Text("\(transmit.companderLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.companderLevel) }, send: { .levelSlider(.companderLevel, Int($0)) }), in: 0...100)
      }
    }
//    .frame(width: 180)
  }
}

struct TxFilterView: View {
  let viewStore: ViewStore<Ph2Feature.State, Ph2Feature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 40) {
        Group {
          Text("Tx Filter")
          Stepper(value: viewStore.binding(
            get: {_ in  transmit.txFilterLow },
            send: { .txFilterLowCut($0) }),
                  in:  0...transmit.txFilterHigh,
                  step: 50) {
            Text("\(transmit.txFilterLow)").frame(width: 40, alignment: .trailing) }
          
          Stepper(value: viewStore.binding(
            get: {_ in  transmit.txFilterHigh },
            send: { .txFilterHighCut($0) }),
                  in: 0...10_000,
                  step: 50) {
            Text("\(transmit.txFilterHigh)").frame(width: 40, alignment: .trailing) }
        }
      }
      HStack(spacing: 60) {
        Group {
          Text("Low Cut")
          Text("High Cut")
        }
        .font(.footnote)
      }
      .padding(.leading, 90)
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
          get: {_ in transmit.voxEnabled},
          send: .voxButton )) { Text("Bias").frame(width: 55) }
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.voxEnabled},
          send: .voxButton )) { Text("Boost").frame(width: 55) }
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.voxEnabled},
          send: .voxButton )) { Text("Meter in Rx").frame(width: 70) }
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
