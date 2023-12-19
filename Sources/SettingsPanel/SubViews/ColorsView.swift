//
//  ColorsView.swift
//  ViewFeatures/SettingsFeature/Colors
//
//  Created by Douglas Adams on 5/13/21.
//

import SwiftUI

import SettingsModel

public struct ColorsView: View {
  @Environment(SettingsModel.self) private var settings
    
  public init() {}
  
 public var body: some View {
    @Bindable var settingsBindable = settings

    VStack {
      Grid(alignment: .leading, horizontalSpacing: 35, verticalSpacing: 15) {
        GridRow() {
          Text("Spectrum")
          ColorPicker("", selection: $settingsBindable.spectrumLine).labelsHidden()
          Button("Reset") { settings.reset(.spectrumLine) }
          
          Text("Spectrum Fill")
          ColorPicker("", selection: $settingsBindable.spectrumFill).labelsHidden()
          Button("Reset") { settings.reset(.spectrumFill) }
        }
        GridRow() {
          Text("Freq Legend")
          ColorPicker("", selection: $settingsBindable.frequencyLegend).labelsHidden()
          Button("Reset") { settings.reset(.frequencyLegend) }
          
          Text("Db Legend")
          ColorPicker("", selection: $settingsBindable.dbLegend).labelsHidden()
          Button("Reset") { settings.reset(.dbLegend) }
        }
        GridRow() {
          Text("Grid lines")
          ColorPicker("", selection: $settingsBindable.gridLines).labelsHidden()
          Button("Reset") { settings.reset(.gridLines) }
          
          Text("Db lines")
          ColorPicker("", selection: $settingsBindable.dbLines).labelsHidden()
          Button("Reset") { settings.reset(.dbLines) }
        }
        GridRow() {
          Text("Marker edge")
          ColorPicker("", selection: $settingsBindable.markerEdge).labelsHidden()
          Button("Reset") { settings.reset(.markerEdge) }
          
          Text("Marker segment")
          ColorPicker("", selection: $settingsBindable.markerSegment).labelsHidden()
          Button("Reset") { settings.reset(.markerSegment) }
        }
        GridRow() {
          Text("Slice filter")
          ColorPicker("", selection: $settingsBindable.sliceFilter).labelsHidden()
          Button("Reset") { settings.reset(.sliceFilter) }
          
          Text("Marker")
          ColorPicker("", selection: $settingsBindable.marker).labelsHidden()
          Button("Reset") { settings.reset(.marker) }
        }
        GridRow() {
          Text("Tnf (Inactive)")
          ColorPicker("", selection: $settingsBindable.tnfInactive).labelsHidden()
          Button("Reset") { settings.reset(.tnfInactive) }
          
          Text("Tnf (normal)")
          ColorPicker("", selection: $settingsBindable.tnfNormal).labelsHidden()
          Button("Reset") { settings.reset(.tnfNormal) }
        }
        GridRow() {
          Text("Tnf (deep)")
          ColorPicker("", selection: $settingsBindable.tnfDeep).labelsHidden()
          Button("Reset") { settings.reset(.tnfDeep) }
          
          Text("Tnf (very deep)")
          ColorPicker("", selection: $settingsBindable.tnfVeryDeep).labelsHidden()
          Button("Reset") { settings.reset(.tnfVeryDeep) }
        }
        GridRow() {
          Text("Tnf (permanent)")
          ColorPicker("", selection: $settingsBindable.tnfPermanent).labelsHidden()
          Button("Reset") { settings.reset(.tnfPermanent) }
          
          Text("Background")
          ColorPicker("", selection: $settingsBindable.background).labelsHidden()
          Button("Reset") { settings.reset(.background) }
        }
        GridRow() {
          Text("Slice (active)")
          ColorPicker("", selection: $settingsBindable.sliceActive).labelsHidden()
          Button("Reset") { settings.reset(.sliceActive) }
          
          Text("Slice (Inactive)")
          ColorPicker("", selection: $settingsBindable.sliceInactive).labelsHidden()
          Button("Reset") { settings.reset(.sliceInactive) }
        }
      }
      Divider().background(Color.blue)
      HStack {
        Spacer()
        Button("Reset All") { settings.reset() }
        Spacer()
      }
    }
  }
}

#Preview {
  ColorsView()
    .frame(width: 600, height: 350)
    .padding()
}

