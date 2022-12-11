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
      VStack(alignment: .leading, spacing: 13) {
        ButtonsView(viewStore: viewStore, transmit: apiModel.transmit)
        TxFilterView(viewStore: viewStore, transmit: apiModel.transmit)
        MicButtonsView(viewStore: viewStore, transmit: apiModel.transmit)
        Divider().background(.blue)
      }
      .frame(width: 260, height: 210)
      .padding(10)
    }
  }
}

struct ButtonsView: View {
  let viewStore: ViewStore<Ph2Feature.State, Ph2Feature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    HStack(spacing: 10)  {
      VStack(alignment: .center, spacing: 15) {
        Group {
          Text("AM Carrier")
          Toggle(isOn: viewStore.binding(
            get: {_ in transmit.voxEnabled},
            send: .voxButton )) { Text("VOX") }
          Text("Vox Delay")
          Toggle(isOn: viewStore.binding(
            get: {_ in transmit.companderEnabled},
            send: .dexpButton )) { Text("DEXP") }
        }.toggleStyle(.button)
      }
      SlidersView(viewStore: viewStore, transmit: transmit)
    }
  }
}

struct SlidersView: View {
  let viewStore: ViewStore<Ph2Feature.State, Ph2Feature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    VStack(spacing: 12) {
      HStack(spacing: 10) {
        Text("\(transmit.carrierLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.carrierLevel) }, send: { .levelSlider(.amCarrierLevel, Int($0)) }), in: 0...100)
      }
      HStack(spacing: 10) {
        Text("\(transmit.voxLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.voxLevel) }, send: { .levelSlider(.voxLevel, Int($0)) }), in: 0...100)
      }
      HStack(spacing: 10) {
        Text("\(transmit.voxDelay)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.voxDelay) }, send: { .levelSlider(.voxDelay, Int($0)) }), in: 0...100)
      }
      HStack(spacing: 10) {
        Text("\(transmit.companderLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.companderLevel) }, send: { .levelSlider(.companderLevel, Int($0)) }), in: 0...100)
      }
    }
  }
}

struct TxFilterView: View {
  let viewStore: ViewStore<Ph2Feature.State, Ph2Feature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 20) {
//        Group {
//          Text("Tx Filter")
//          TextField("", value: viewStore.binding(
//            get: {_ in  transmit.txFilterLow },
//            send: { .txFilterLowCut($0) }), format: .number).multilineTextAlignment(.trailing)
//          TextField("", value: viewStore.binding(
//            get: {_ in  transmit.txFilterHigh },
//            send: { .txFilterHighCut($0) }), format: .number)
//          .multilineTextAlignment(.trailing)
//        }.frame(width: 70)

        Group {
          Text("Tx Filter")
          Stepper(value: viewStore.binding(
            get: {_ in  transmit.txFilterLow },
            send: { .txFilterLowCut($0) }),
                  in:  0...(transmit.txFilterHigh - 50),
                  step: 50) {
            Text("\(transmit.txFilterLow)").frame(width: 40, alignment: .trailing).border(.red) }
          
          Stepper(value: viewStore.binding(
            get: {_ in  transmit.txFilterHigh },
            send: { .txFilterHighCut($0) }),
                  in: (transmit.txFilterLow + 50)...10_000,
                  step: 50) {
            Text("\(transmit.txFilterHigh)").frame(width: 40, alignment: .trailing).border(.red) }
        }.frame(width: 80)

      }
    }
  }
}

struct MicButtonsView: View {
  let viewStore: ViewStore<Ph2Feature.State, Ph2Feature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    HStack(alignment: .center, spacing: 5) {
      Image(systemName: transmit.micBiasEnabled ? "b.circle.fill" : "b.circle").font(.title).help("Mic Bias")
        .help("            Bias")
        .onTapGesture { viewStore.send(.micBiasButton) }
      Image(systemName: transmit.micBoostEnabled ? "plus.circle.fill" : "plus.circle").font(.title).help("Mic Boost")
        .help("            Boost")
        .onTapGesture { viewStore.send(.micBoostButton) }
      Image(systemName: transmit.metInRxEnabled ? "m.circle.fill" : "m.circle").font(.title).help("Meter in Rx")
        .help("            Meter in Rx")
        .onTapGesture { viewStore.send(.meterInRxButton) }
      HStack(spacing: 20) {
        Group {
          Text("Low Cut")
          Text("High Cut")
        }
        .font(.footnote)
        .frame(width: 50)
        .padding(.leading, 20)
      }
    }
  }
}



// ----------------------------------------------------------------------------
// MARK: - Preview

struct Ph2View_Previews: PreviewProvider {
  static var previews: some View {
    Ph2View(store: Store(initialState: Ph2Feature.State(), reducer: Ph2Feature()))
  }
}
