//
//  ProfilesSettingsView.swift
//  
//
//  Created by Douglas Adams on 12/30/22.
//

import ComposableArchitecture
import SwiftUI

import Objects

public enum ProfileType: String {
  case mic
  case tx
  case global
}

struct ProfilesSettingsView: View {
  let store: StoreOf<ProfilesSettingsFeature>
  
  @AppStorage("selectedProfileType") var selectedProfileType: ProfileType = .mic
  
  @Dependency(\.apiModel) var apiModel
  
  var body: some View {
    
    if apiModel.radio == nil {
      VStack {
        Text("Radio must be connected").font(.title).foregroundColor(.red)
        Text("to use Profile Settings").font(.title).foregroundColor(.red)
      }
      
    } else {
      ProfileView(store: store, profile: apiModel.profiles[id: selectedProfileType.rawValue]!, profileType: selectedProfileType)
    }
  }
}

private struct ProfileView: View {
  let store: StoreOf<ProfilesSettingsFeature>
  let profile: Profile
  let profileType: ProfileType
  
  @State var selectedProfileNameId: UUID? = nil
  @State var newProfileName = ""
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading) {
        HStack(spacing: 40) {
          ControlGroup {
            Toggle("MIC", isOn: viewStore.binding(
              get: {_ in profileType == .mic},
              send: .selectedType(.mic) ))
            Toggle("TX", isOn: viewStore.binding(
              get: {_ in profileType == .tx},
              send: .selectedType(.tx) ))
            Toggle("GLOBAL", isOn: viewStore.binding(
              get: {_ in profileType == .global},
              send: .selectedType(.global) ))
          }
        }
        .font(.title)
        .foregroundColor(.blue)
        
        Spacer()
        TextField("New Profile Name", text: $newProfileName)
        Spacer()
        
        List(profile.list, id: \.id, selection: $selectedProfileNameId) { profileName in
          Text(profileName.name).tag(profileName)
            .foregroundColor(profile.current.name == profileName.name ? .red : nil)
            .onTapGesture {
              selectedProfileNameId = selectedProfileNameId == nil ? profileName.id : nil
            }
        }
        Divider().foregroundColor(.blue)
        
        HStack {
          Spacer()
          Button("New") { viewStore.send(.create(profile.id, newProfileName)) }
            .disabled(newProfileName.isEmpty)
          Group {
            Button("Delete") { viewStore.send(.delete(profile.id, selectedProfileNameId!)) }
            Button("Reset") { viewStore.send(.reset(profile.id, selectedProfileNameId!)) }
            Button("Load") { viewStore.send(.load(profile.id, selectedProfileNameId!)) }
          }.disabled(selectedProfileNameId == nil)
          Spacer()
        }
      }
    }
  }
}

//private struct ProfileListView: View {
//  let viewStore: ViewStore<ProfilesSettingsFeature.State, ProfilesSettingsFeature.Action>
//  let profile: Profile
//
//  @State var currentSelection = ""
//
//  var body: some View {
//    ScrollView(.vertical, showsIndicators: true) {
//      VStack(alignment: .leading) {
//        List(profile.list) {
//          Text($0.name).tag($0.id)
//        }
//      }
//    }
//  }
//}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct ProfilesSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    ProfilesSettingsView(store: Store(
      initialState: ProfilesSettingsFeature.State(),
      reducer: ProfilesSettingsFeature())
    )
    .frame(width: 600, height: 350)
    .padding()
    
  }
}
