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
  
  @Dependency(\.apiModel) var apiModel
  
  public init(store: StoreOf<CwFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 10)  {
        LevelIndicatorView(level: 0.25, type: .alc)
          .padding(.bottom, 10)
        
        ButtonsView(viewStore: viewStore, transmit: apiModel.transmit)
        BottomButtonsView(viewStore: viewStore, transmit: apiModel.transmit)
        Divider().background(.blue)
      }
      .frame(width: 260, height: 210)
      .padding(10)
    }
  }
}

struct ButtonsView: View {
  let viewStore: ViewStore<CwFeature.State, CwFeature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    HStack {
      VStack(alignment: .center, spacing: 13){
        Group {
          Text("Delay")
          Text("Speed")
          Toggle("Sidetone", isOn: viewStore.binding(
            get: {_ in transmit.cwSidetoneEnabled },
            send: .sidetoneButton )).toggleStyle(.button)
          Text("Pan").frame(width: 70)
        }.frame(width: 70)
      }
      SlidersView(viewStore: viewStore, transmit: transmit)
    }
  }
}

struct SlidersView: View {
  let viewStore: ViewStore<CwFeature.State, CwFeature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    VStack(alignment: .trailing, spacing: 15) {
      Group {
        Text("\(transmit.cwBreakInDelay, specifier: "%d")")
        Text("\(transmit.cwSpeed, specifier: "%d")")
        Text("\(transmit.cwMonitorGain, specifier: "%d")")
        Text("\(transmit.cwMonitorPan - 50, specifier: "%d")")
      }.frame(width: 40, alignment: .trailing)
    }
    
    VStack(alignment: .leading, spacing: 10) {
      Group {
        Slider(value: viewStore.binding(get: {_ in Double(transmit.cwBreakInDelay) }, send: { .delayLevel( Int($0)) }), in: 0...2000)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.cwSpeed )}, send: { .speedLevel( Int($0)) }), in: 0...100)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.cwMonitorGain) }, send: { .sidetoneGain( Int($0)) }), in: 0...100)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.cwMonitorPan) }, send: { .sidetonePan( Int($0)) }), in: 0...100 ).frame(width: 120)
      }.frame(width: 120)
    }
  }
}

struct BottomButtonsView: View {
  let viewStore: ViewStore<CwFeature.State, CwFeature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    HStack(spacing: 5) {
      Group {
        Toggle("Breakin", isOn: viewStore.binding(
          get: {_ in transmit.cwBreakInEnabled },
          send: .breakinButton ))
        Toggle("Iambic", isOn: viewStore.binding(
          get: {_ in transmit.cwIambicEnabled },
          send: .iambicButton ))
      }.toggleStyle(.button).frame(width: 70)
      Text("Pitch")
      Stepper(value: viewStore.binding(
        get: {_ in  transmit.cwPitch },
        send: { .pitchChange($0) }),
              in: 100...6000,
              step: 50) {
        Text("\(transmit.cwPitch)").frame(width: 40, alignment: .trailing).border(.red) }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct CwView_Previews: PreviewProvider {
  static var previews: some View {
    CwView(store: Store(initialState: CwFeature.State(), reducer: CwFeature()))
  }
}
