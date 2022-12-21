//
//  DisplayView.swift
//  
//
//  Created by Douglas Adams on 12/21/22.
//

import ComposableArchitecture
import SwiftUI

import Objects

public struct DisplayView: View {
  let store: StoreOf<DisplayFeature>
  @ObservedObject var apiModel: ApiModel
  
  public init(store: StoreOf<DisplayFeature>, apiModel: ApiModel) {
    self.store = store
    self.apiModel = apiModel
  }
  
    public var body: some View {

      WithViewStore(self.store, observe: { $0 }) { viewStore in
        
        let panadapter = apiModel.panadapters[id: viewStore.panadapterId] ?? Panadapter("0x99999999".streamId!)
        let waterfallId = apiModel.panadapters[id: viewStore.panadapterId]?.waterfallId ?? "0x99999998".streamId!
        let waterfall = apiModel.waterfalls[id: waterfallId] ?? Waterfall("0x99999998".streamId!)

        VStack(alignment: .leading) {
          PanadapterSettings(viewStore: viewStore, panadapter: panadapter)
          Divider().foregroundColor(.blue)
          WaterfallSettings(viewStore: viewStore, waterfall: waterfall)
        }
        .frame(width: 250)
        .padding(5)
      }
    }
}

private struct PanadapterSettings: View {
  let viewStore: ViewStore<DisplayFeature.State, DisplayFeature.Action>
  @ObservedObject var panadapter: Panadapter

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(spacing: 10) {
        Text("Average").frame(width: 90, alignment: .leading)
        Text("\(panadapter.average)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(panadapter.average) }, send: { .averageLevel( Int($0)) }), in: 0...100)
      }
      HStack(spacing: 10) {
        Text("Frames/sec").frame(width: 90, alignment: .leading)
        Text("\(panadapter.fps)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(panadapter.fps) }, send: { .fpsLevel( Int($0)) }), in: 0...100)
      }
      HStack(spacing: 10) {
        Text("Fill").frame(width: 90, alignment: .leading)
        Text("\(panadapter.fillLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(panadapter.fillLevel) }, send: { .fillLevel( Int($0)) }), in: 0...100)
      }
      HStack {
        Text("Weighted Average").frame(width: 130, alignment: .leading)
        Toggle("", isOn: viewStore.binding(
          get: {_ in panadapter.weightedAverageEnabled },
          send: .weightedAverageButton ))
      }
    }
  }
}

private struct WaterfallSettings: View {
  let viewStore: ViewStore<DisplayFeature.State, DisplayFeature.Action>
  @ObservedObject var waterfall: Waterfall

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack (spacing: 45){
        Text("Color Gradient")
        Picker("", selection: viewStore.binding(
          get: {_ in  waterfall.selectedGradient },
          send: { .gradientPicker($0) })) {
            ForEach(Waterfall.GradientEnum.allCases, id: \.rawValue) {
              Text($0.rawValue).tag($0.rawValue)
            }
          }
          .labelsHidden()
          .pickerStyle(.menu)
          .frame(width: 70, alignment: .leading)
      }
      
      HStack(spacing: 10) {
        Text("Color Gain").frame(width: 90, alignment: .leading)
        Text("\(waterfall.colorGain)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(waterfall.colorGain) }, send: { .colorGain( Int($0)) }), in: 0...100)
      }
      HStack(spacing: 10) {
        Text("Auto Black").frame(width: 65, alignment: .leading)
        Toggle("", isOn: viewStore.binding(
          get: {_ in  waterfall.autoBlackEnabled },
          send: .autoBlackButton )).labelsHidden()
        Text("\(waterfall.autoBlackLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(waterfall.autoBlackLevel) }, send: { .autoBlackLevel( Int($0)) }), in: 0...100)
      }
      HStack(spacing: 10) {
        Text("Line Duration").frame(width: 90, alignment: .leading)
        Text("\(waterfall.lineDuration)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(waterfall.lineDuration) }, send: { .lineDurationLevel( Int($0)) }), in: 0...100)
      }
    }
  }
}

struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
      DisplayView(store: Store(initialState: DisplayFeature.State(panadapterId: "0x99999999".streamId!), reducer: DisplayFeature()), apiModel: ApiModel())
        .frame(width: 250)
        .padding(5)
    }
}
