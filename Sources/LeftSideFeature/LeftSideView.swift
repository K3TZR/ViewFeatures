//
// LeftSideView.swift
//  
//
//  Created by Douglas Adams on 12/20/22.
//

import ComposableArchitecture
import SwiftUI

import AntennaFeature
import BandFeature
import DaxFeature
import DisplayFeature
import Objects

public struct LeftSideView: View {
  let store: StoreOf<LeftSideFeature>
  @ObservedObject var apiModel: ApiModel
  
  public init(store: StoreOf<LeftSideFeature>, apiModel: ApiModel) {
    self.store = store
    self.apiModel = apiModel
  }
  
  public var body: some View {
    
    WithViewStore(self.store) { viewStore in
      
      VStack(spacing: 20) {
        Group {
          Button(action: { }) { Text("+Rx").frame(width: 35) }
          Button(action: { }) { Text("+Tnf").frame(width: 35) }
          Button(action: { viewStore.send(.bandButton) }) { Text("Band").frame(width: 35) }
          Button(action: { viewStore.send(.antennaButton) }) { Text("ANT").frame(width: 35) }
          Button(action: { viewStore.send(.displayButton) }) { Text("DISP").frame(width: 35) }
          Button(action: { viewStore.send(.daxButton) }) { Text("DAX").frame(width: 35) }
        }.disabled(apiModel.clientInitialized == false)
      }
      .popover(isPresented: viewStore.binding(get: { $0.antennaPopover }, send: .antennaButton ), arrowEdge: .leading) {
        AntennaView(store: Store(initialState: AntennaFeature.State(panadapterId: viewStore.panadapterId), reducer: AntennaFeature()),
                    apiModel: apiModel)
      }
      .popover(isPresented: viewStore.binding(get: { $0.bandPopover }, send: .bandButton ), arrowEdge: .leading) {
        BandView()
      }
      .popover(isPresented: viewStore.binding(get: { $0.displayPopover }, send: .displayButton ), arrowEdge: .leading) {
        DisplayView(store: Store(initialState: DisplayFeature.State(panadapterId: viewStore.panadapterId), reducer: DisplayFeature()),
                    apiModel: apiModel)
      }
      .popover(isPresented: viewStore.binding(get: { $0.daxPopover }, send: .daxButton ), arrowEdge: .leading) {
        DaxView(store: Store(initialState: DaxFeature.State(panadapterId: viewStore.panadapterId), reducer: DaxFeature()),
                apiModel: apiModel)
      }
    }
  }
}

struct LeftSideView_Previews: PreviewProvider {
  static var previews: some View {
    
    LeftSideView(
      store: Store(
        initialState: LeftSideFeature.State(panadapterId: "0x99999999".streamId!),
        reducer: LeftSideFeature()
      ), apiModel: ApiModel()
    )
  }
}
