//
//  Ph1View.swift
//  
//
//  Created by Douglas Adams on 11/15/22.
//

import ComposableArchitecture
import SwiftUI

//import LevelIndicatorView

// ----------------------------------------------------------------------------
// MARK: - View

public struct Ph1View: View {
  let store: StoreOf<Ph1Feature>

  public init(store: StoreOf<Ph1Feature>) {
    self.store = store
  }

  @State var micValue: CGFloat = -20.0
  @State var compressionValue: CGFloat = -15.0
  @State var selectedMicProfile = "Profile 1"
  @State var micProfiles = ["Profile 1", "Profile 2", "Profile 3"]
  @State var selectedMicSource = "Mic"
  @State var micSources = ["Mic", "Mac", "Dax"]
  @State var micSetting: CGFloat = 0.0
  @State var compressionSetting: CGFloat = 0.0
  @State var monSetting: CGFloat = 0.0
  
  @State var acc = true
  @State var dax = false
  @State var proc = false
  @State var mon = false

  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 10) {
        //        VStack(alignment: .leading, spacing: 5)  {
        //          LevelIndicatorView(level: micValue, type: .micLevel)
        //          LevelIndicatorView(level: compressionValue, type: .compression)
        //          //      Spacer()
        //        }
        Rectangle().frame(height: 30)
        Rectangle().frame(height: 30)
        
        HStack(spacing: 30) {
          Picker("", selection: $selectedMicProfile) {
            ForEach(micProfiles, id: \.self) {
              Text($0)
            }
          }
          .labelsHidden()
          .pickerStyle(.menu)
          .frame(width: 185, alignment: .leading)
          Button("Save", action: {}).font(.system(size: 10)).buttonStyle(BorderlessButtonStyle()).foregroundColor(.blue)
        }
        
        HStack(spacing: 10) {
          Group {
            VStack(alignment: .leading, spacing: 5) {
              Picker("", selection: $selectedMicSource) {
                ForEach(micSources, id: \.self) {
                  Text($0)
                }
              }
              .labelsHidden()
              .pickerStyle(.menu)
              Group {
                Text("-").hidden().font(.footnote)
                Toggle("Proc", isOn: $proc)
                Toggle("Mon", isOn: $mon)
              }.toggleStyle(.button)
            }
          }.frame(width: 60)
          
          VStack {
            HStack(spacing: 0) {
              VStack {
                Slider(value: $micSetting, in: -1...1)
                HStack(spacing: 35) {
                  Text("NOR")
                  Text("DX")
                  Text("DX+")
                }.font(.footnote)
                Slider(value: $compressionSetting, in: -1...1)
              }.frame(width: 130)
              
              VStack {
                Toggle("ACC", isOn: $acc)
                Text("-").hidden().font(.footnote)
                Toggle("DAX", isOn: $dax)
              }.toggleStyle(.button).frame(width: 60)
            }
            Slider(value: $monSetting, in: -1...1)
          }
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

struct Ph1View_Previews: PreviewProvider {
    static var previews: some View {
      Ph1View(store: Store(initialState: Ph1Feature.State(), reducer: Ph1Feature()))
    }
}
