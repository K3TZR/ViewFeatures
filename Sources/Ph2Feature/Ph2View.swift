//
//  Ph2View.swift
//  
//
//  Created by Douglas Adams on 11/15/22.
//

import ComposableArchitecture
import SwiftUI

//import LevelIndicatorView

// ----------------------------------------------------------------------------
// MARK: - View

public struct Ph2View: View {
  let store: StoreOf<Ph2Feature>
  
  public init(store: StoreOf<Ph2Feature>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 13) {
//
//        HStack(spacing: 10)  {
//          VStack(alignment: .center, spacing: 15) {
//            Group {
//              Text("AM Carrier")
//              Toggle(isOn: viewStore.binding(
//                get: {_ in transmit.voxEnabled},
//                send: .voxButton( transmit.voxEnabled ))) { Text("VOX") }
//              Text("Vox Delay")
//              Toggle(isOn: viewStore.binding(
//                get: {_ in transmit.companderEnabled},
//                send: .dexpButton( transmit.companderEnabled ))) { Text("DEXP") }
//            }.toggleStyle(.button)
//          }
//
//          VStack(spacing: 12) {
//            Slider(value: viewStore.binding(get: {_ in Double(transmit.carrierLevel) }, send: { .levelChange(.amCarrierLevel, Int($0)) }), in: 0...100, step: 1)
//            Slider(value: viewStore.binding(get: {_ in Double(transmit.voxLevel) }, send: { .levelChange(.voxLevel, Int($0)) }), in: 0...100, step: 1)
//            Slider(value: viewStore.binding(get: {_ in Double(transmit.voxDelay) }, send: { .levelChange(.voxDelay, Int($0)) }), in: 0...100, step: 1)
//            Slider(value: viewStore.binding(get: {_ in Double(transmit.companderLevel) }, send: { .levelChange(.companderLevel, Int($0)) }), in: 0...100, step: 1)
//          }
//        }
//        VStack(alignment: .leading, spacing: 0) {
//          HStack(spacing: 20) {
//            Group {
//              Text("Tx Filter")
//              TextField("", value: viewStore.binding(
//                get: {_ in  transmit.txFilterLow },
//                send: { .lowCutChange($0) }), format: .number).multilineTextAlignment(.trailing)
//              TextField("", value: viewStore.binding(
//                get: {_ in  transmit.txFilterHigh },
//                send: { .highCutChange($0) }), format: .number)
//              .multilineTextAlignment(.trailing)
//            }.frame(width: 70)
//          }
//          HStack(spacing: 20) {
//            Group {
//              Text("")
//              Text("Low Cut")
//              Text("High Cut")
//            }
//            .font(.footnote)
//            .frame(width: 70)
//          }
//        }
//        HStack(alignment: .center, spacing: 20) {
//          Spacer()
//          Image(systemName: transmit.micBiasEnabled ? "b.circle.fill" : "b.circle").font(.title).help("Mic Bias")
//            .onTapGesture { viewStore.send(.micBiasButton(transmit.micBiasEnabled) ) }
//          Image(systemName: transmit.micBoostEnabled ? "plus.circle.fill" : "plus.circle").font(.title).help("Mic Boost")
//            .onTapGesture { viewStore.send(.micBoostButton(transmit.micBoostEnabled)) }
//          Image(systemName: transmit.metInRxEnabled ? "m.circle.fill" : "m.circle").font(.title).help("Meter in Rx")
//            .onTapGesture { viewStore.send(.meterInRxButton(transmit.metInRxEnabled)) }
//          Spacer()
//        }
//        Divider().background(.blue)
      }
      .frame(width: 260, height: 210)
      .padding(10)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

//struct Ph2View_Previews: PreviewProvider {
//  static var previews: some View {
//    Ph2View(store: Store(initialState: Ph2Feature.State(transmit: Transmit.shared), reducer: Ph2Feature()), transmit: Transmit.shared)
//  }
//}
