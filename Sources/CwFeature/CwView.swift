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
      VStack(alignment: .center, spacing: 10)  {
        LevelIndicatorView(level: 0.25, type: .alc)
          .padding(.bottom, 10)
        
        HStack {
          ButtonsView(viewStore: viewStore, transmit: apiModel.transmit)
          SlidersView(viewStore: viewStore, transmit: apiModel.transmit)
        }
        BottomButtonsView(viewStore: viewStore, transmit: apiModel.transmit)
        Divider().background(.blue)
      }
      .frame(width: 275)
    }
  }
}

struct ButtonsView: View {
  let viewStore: ViewStore<CwFeature.State, CwFeature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
      VStack(alignment: .center, spacing: 13){
        Group {
          Text("Delay")
          Text("Speed")
          Toggle(isOn: viewStore.binding(
            get: {_ in transmit.cwSidetoneEnabled },
            send: .sidetoneButton )) {Text("Sidetone").frame(width: 55)}
          .toggleStyle(.button)
          Text("Pan")
        }
        .frame(width: 80)
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
        Slider(value: viewStore.binding(get: {_ in Double(transmit.cwMonitorPan) }, send: { .sidetonePan( Int($0)) }), in: 0...100 )
      }
    }
  }
}

struct BottomButtonsView: View {
  let viewStore: ViewStore<CwFeature.State, CwFeature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    HStack(spacing: 15) {
      Group {
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.cwBreakInEnabled },
          send: .breakinButton )) {Text("BreakIn").frame(width: 55)}
        Toggle("Iambic", isOn: viewStore.binding(
          get: {_ in transmit.cwIambicEnabled },
          send: .iambicButton ))
      }
      .toggleStyle(.button)
      
      Text("Pitch")
      Stepper(value: viewStore.binding(
        get: {_ in  transmit.cwPitch },
        send: { .pitchChange($0) }),
              in: 100...6000,
              step: 50) {
        Text("\(transmit.cwPitch)").frame(width: 40, alignment: .trailing).background(Color.secondary) }
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
