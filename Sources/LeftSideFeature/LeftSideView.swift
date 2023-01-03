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
      
      Group {
        if viewStore.vertical {
          VerticalView(viewStore: viewStore, apiModel: apiModel)
        } else {
          HorizontalView(viewStore: viewStore, apiModel: apiModel)
        }
      }
      .popover(isPresented: viewStore.binding(get: { $0.antennaPopover }, send: .antennaButton ), arrowEdge: viewStore.vertical ? .leading : .top) {
        AntennaView(store: Store(initialState: AntennaFeature.State(), reducer: AntennaFeature()),
                    apiModel: apiModel)
      }
      .popover(isPresented: viewStore.binding(get: { $0.bandPopover }, send: .bandButton ), arrowEdge: viewStore.vertical ? .leading : .top) {
        BandView()
      }
      .popover(isPresented: viewStore.binding(get: { $0.displayPopover }, send: .displayButton ), arrowEdge: viewStore.vertical ? .leading : .top) {
        DisplayView(store: Store(initialState: DisplayFeature.State(), reducer: DisplayFeature()),
                    apiModel: apiModel)
      }
      .popover(isPresented: viewStore.binding(get: { $0.daxPopover }, send: .daxButton ), arrowEdge: viewStore.vertical ? .leading : .top) {
        DaxView(store: Store(initialState: DaxFeature.State(), reducer: DaxFeature()),
                apiModel: apiModel)
      }
    }
  }
}

private struct VerticalView: View {
  let viewStore: ViewStore<LeftSideFeature.State, LeftSideFeature.Action>
  @ObservedObject var apiModel: ApiModel
  
  public var body: some View {
    VStack(spacing: 30){
      Spacer()
      ButtonsView(viewStore: viewStore, apiModel: apiModel)
      Spacer()
    }
  }
}

private struct HorizontalView: View {
  let viewStore: ViewStore<LeftSideFeature.State, LeftSideFeature.Action>
  @ObservedObject var apiModel: ApiModel
  
  public var body: some View {
    HStack(spacing: 20){
      Spacer()
      ButtonsView(viewStore: viewStore, apiModel: apiModel)
      Spacer()
    }
  }
}

private struct ButtonsView: View {
  let viewStore: ViewStore<LeftSideFeature.State, LeftSideFeature.Action>
  @ObservedObject var apiModel: ApiModel
  
  public var body: some View {
    Group {
      Button(action: { }) { Text("+Rx").frame(width: 35) }
      Button(action: { }) { Text("+Tnf").frame(width: 35) }
      Button(action: { viewStore.send(.bandButton) }) { Text("Band").frame(width: 35) }
      Button(action: { viewStore.send(.antennaButton) }) { Text("ANT").frame(width: 35) }
      Button(action: { viewStore.send(.displayButton) }) { Text("DISP").frame(width: 35) }
      Button(action: { viewStore.send(.daxButton) }) { Text("DAX").frame(width: 35) }
    }.disabled(apiModel.clientInitialized == false)
  }
}

struct LeftSideView_Previews: PreviewProvider {
  static var previews: some View {
    
    LeftSideView(
      store: Store(
        initialState: LeftSideFeature.State(),
        reducer: LeftSideFeature()
      ), apiModel: ApiModel()
    )
  }
}
