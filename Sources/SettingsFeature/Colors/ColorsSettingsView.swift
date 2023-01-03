//
//  ColorsSettingsView.swift
//  xMini6001
//
//  Created by Douglas Adams on 5/13/21.
//

import ComposableArchitecture
import SwiftUI

struct ColorsSettingsView: View {
  let store: StoreOf<ColorsSettingsFeature>
  
  var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        Grid(alignment: .leading, horizontalSpacing: 35, verticalSpacing: 15) {
          TopHalfView(viewStore: viewStore)
          BottomHalfView(viewStore: viewStore)
        }
        HStack {
          Spacer()
          Button("Reset All") { viewStore.send(.resetAll) }
//          Spacer()
        }
      }
      .onAppear{ viewStore.send(.setDefaults) }
    }
  }
}

private struct TopHalfView: View {
  let viewStore: ViewStore<ColorsSettingsFeature.State, ColorsSettingsFeature.Action>
  
  var body: some View {
    
    GridRow() {
      Text("Spectrum")
      ColorPicker("", selection: viewStore.binding(
        get: \.spectrum,
        send: { .color(\.spectrum, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.spectrum, "spectrum")) }
      
      Text("Spectrum Fill")
      ColorPicker("", selection: viewStore.binding(
        get: \.spectrumFill,
        send: { .color(\.spectrumFill, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.spectrumFill, "spectrumFill")) }
    }
    GridRow() {
      Text("Freq Legend")
      ColorPicker("", selection: viewStore.binding(
        get: \.frequencyLegend,
        send: { .color(\.frequencyLegend, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.frequencyLegend, "frequencyLegend")) }
      
      Text("Db Legend")
      ColorPicker("", selection: viewStore.binding(
        get: \.dbLegend,
        send: { .color(\.dbLegend, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.dbLegend, "dbLegend")) }
    }
    GridRow() {
      Text("Grid lines")
      ColorPicker("", selection: viewStore.binding(
        get: \.gridLines,
        send: { .color(\.gridLines, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.gridLines, "gridLines")) }
      
      Text("Db lines")
      ColorPicker("", selection: viewStore.binding(
        get: \.dbLines,
        send: { .color(\.dbLines, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.dbLines, "dbLines")) }
    }
    GridRow() {
      Text("Marker edge")
      ColorPicker("", selection: viewStore.binding(
        get: \.markerEdge,
        send: { .color(\.markerEdge, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.markerEdge, "markerEdge")) }
      
      Text("Marker segment")
      ColorPicker("", selection: viewStore.binding(
        get: \.markerSegment,
        send: { .color(\.markerSegment, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.markerSegment, "markerSegment")) }
    }
  }
}

private struct BottomHalfView: View {
  let viewStore: ViewStore<ColorsSettingsFeature.State, ColorsSettingsFeature.Action>
  
  var body: some View {
    
    GridRow() {
      Text("Slice filter")
      ColorPicker("", selection: viewStore.binding(
        get: \.sliceFilter,
        send: { .color(\.sliceFilter, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.sliceFilter, "sliceFilter")) }
      
      Text("Marker")
      ColorPicker("", selection: viewStore.binding(
        get: \.marker,
        send: { .color(\.marker, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.marker, "marker")) }
    }
    GridRow() {
      Text("Tnf (active)")
      ColorPicker("", selection: viewStore.binding(
        get: \.tnfActive,
        send: { .color(\.tnfActive, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.tnfActive, "tnfActive")) }
      
      Text("Tnf (Inactive)")
      ColorPicker("", selection: viewStore.binding(
        get: \.tnfInactive,
        send: { .color(\.tnfInactive, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.tnfInactive, "tnfInactive")) }
    }
    GridRow() {
      Text("Slice (active)")
      ColorPicker("", selection: viewStore.binding(
        get: \.sliceActive,
        send: { .color(\.sliceActive, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.sliceActive, "sliceActive")) }
      
      Text("Slice (Inactive)")
      ColorPicker("", selection: viewStore.binding(
        get: \.sliceInactive,
        send: { .color(\.sliceInactive, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.sliceInactive, "sliceInactive")) }
    }
    GridRow() {
      Text("Background")
      ColorPicker("", selection: viewStore.binding(
        get: \.background,
        send: { .color(\.background, $0) })).labelsHidden()
      Button("Reset") { viewStore.send(.reset(\.background, "background")) }
    }
  }
}


struct ColorsSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    ColorsSettingsView(store: Store(
      initialState: ColorsSettingsFeature.State(),
      reducer: ColorsSettingsFeature())
    )
    .frame(width: 600, height: 350)
    .padding()
  }
}
