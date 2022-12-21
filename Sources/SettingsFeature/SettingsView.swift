//
//  SettingsView.swift
//  
//
//  Created by Douglas Adams on 12/21/22.
//

import ComposableArchitecture
import SwiftUI

import Objects

public struct SettingsView: View {
  let store: StoreOf<SettingsFeature>
  @ObservedObject var apiModel: ApiModel
  
  public init(store: StoreOf<SettingsFeature>, apiModel: ApiModel) {
    self.store = store
    self.apiModel = apiModel
  }
  
  public var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      
      TabView {
        Group {
          RadioSettingsView()
            .tabItem {
              Text("Radio")
              Image(systemName: "antenna.radiowaves.left.and.right")
            }.padding(.horizontal, 10)
          
          NetworkSettingsView()
            .tabItem {
              Text("Network")
              Image(systemName: "wifi")
            }
          GpsSettingsView()
            .tabItem {
              Text("Gps")
              Image(systemName: "globe")
            }
          TxSettingsView()
            .tabItem {
              Text("Tx")
              Image(systemName: "bolt.horizontal")
            }
          PhoneCwSettingsView()
            .tabItem {
              Text("Phone/Cw")
              Image(systemName: "mic")
            }
          RxSettingsView()
            .tabItem {
              Text("Rx")
              Image(systemName: "headphones")
            }
        }
        Group {
          FiltersSettingsView()
            .tabItem {
              Text("Filters")
              Image(systemName: "camera.filters")
            }
          XvtrSettingsView()
            .tabItem {
              Text("Xvtr")
              Image(systemName: "arrow.up.arrow.down.circle")
            }
          ColorsSettingsView()
            .tabItem {
              Text("Colors")
              Image(systemName: "eyedropper")
            }
            .onDisappear(perform: {
              // close the ColorPicker (if open)
              if NSColorPanel.shared.isVisible {
                NSColorPanel.shared.performClose(nil)
              }
            })
          InfoSettingsView()
            .tabItem {
              Text("Info")
              Image(systemName: "info.circle")
            }
          OtherSettingsView()
            .tabItem {
              Text("Other")
              Image(systemName: "doc.circle")
            }
        }
      }
    }
    .frame(width: 640, height: 440)
    .padding()
  }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
      SettingsView(store: Store(initialState: SettingsFeature.State(), reducer: SettingsFeature()), apiModel: ApiModel())
        .frame(width: 600)
        .padding(5)
    }
}
