//
//  CwView.swift
//  
//
//  Created by Douglas Adams on 11/15/22.
//

import ComposableArchitecture
import SwiftUI

import Objects
import LevelIndicatorView

// ----------------------------------------------------------------------------
// MARK: - View

public struct CwView: View {
  let store: StoreOf<CwFeature>
  @ObservedObject var transmit: Transmit
  @ObservedObject var alcMeter: Meter

  public init(store: StoreOf<CwFeature>, transmit: Transmit, alcMeter: Meter) {
    self.store = store
    self.transmit = transmit
    self.alcMeter = alcMeter
  }
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 10)  {
        LevelIndicatorView(level: 0.25, type: .alc)
          .padding(.bottom, 10)
        
        HStack {
          VStack(alignment: .center, spacing: 10){
            Group {
              Text("Delay")
              Text("Speed")
              Toggle("Sidetone", isOn: viewStore.binding(
                get: {_ in transmit.cwSidetoneEnabled },
                send: .sidetoneButton( transmit.cwSidetoneEnabled) )).toggleStyle(.button)
            }.frame(width: 70)
          }
          
          VStack(alignment: .trailing, spacing: 15) {
            Group {
              Text("\(transmit.cwBreakInDelay, specifier: "%d")")
              Text("\(transmit.cwSpeed, specifier: "%d")")
              Text("\(transmit.cwMonitorGain, specifier: "%.0f")")
            }.frame(width: 40, alignment: .trailing)
          }
          
          VStack(alignment: .leading, spacing: 10) {
            Group {
              Slider(value: viewStore.binding(get: {_ in Double(transmit.cwBreakInDelay) }, send: { .delayLevel( Int($0)) }), in: 0...2000, step: 10)
              Slider(value: viewStore.binding(get: {_ in Double(transmit.cwSpeed )}, send: { .speedLevel( Int($0)) }), in: 0...100, step: 1)
              Slider(value: viewStore.binding(get: {_ in Double(transmit.cwMonitorGain) }, send: { .sidetoneGain( Int($0)) }), in: 0...100, step: 1)
            }.frame(width: 120)
          }
        }
        HStack {
          Text("Pan").frame(width: 70)
          Text("L").frame(width: 30, alignment: .trailing)
          Slider(value: viewStore.binding(get: {_ in Double(transmit.cwMonitorPan) }, send: { .sidetonePan( Int($0)) }), in: 0...100, step: 1).frame(width: 120)
          Text("R")
        }
        HStack(spacing: 10) {
          Group {
            Toggle("Breakin", isOn: viewStore.binding(
              get: {_ in transmit.cwBreakInEnabled },
              send: .breakinButton(transmit.cwBreakInEnabled) ))
            Toggle("Iambic", isOn: viewStore.binding(
              get: {_ in transmit.cwIambicEnabled },
              send: .iambicButton(transmit.cwIambicEnabled) ))
          }.toggleStyle(.button).frame(width: 70)
          Text("Pitch")
          TextField("", value: viewStore.binding(
            get: {_ in  transmit.cwPitch },
            send: { .pitchChange($0) }), format: .number).multilineTextAlignment(.trailing)
        }
        Divider().background(.blue)
      }
      .frame(width: 260, height: 210)
      .padding(10)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct CwView_Previews: PreviewProvider {
    static var previews: some View {
      CwView(store: Store(initialState: CwFeature.State(), reducer: CwFeature()), transmit: Transmit.shared, alcMeter: ApiModel.shared.meters[id: 1]!)
    }
}
