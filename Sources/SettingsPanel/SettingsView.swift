//
//  SettingsView.swift
//  SettingsFeature/SettingsFeature
//
//
//  Created by Douglas Adams on 12/21/22.
//

import SwiftUI

import FlexApi
import SettingsModel

public struct SettingsView: View {
  
  public init() {}
  
  @Environment(SettingsModel.self) private var settings

  public var body: some View {
    @Bindable var settingsBindable = settings
    
    TabView(selection: $settingsBindable.selectedSetting) {
      Group {
        RadioView()
          .tabItem {
            Text(SettingsModel.SelectedSetting.radio.rawValue)
            Image(systemName: "antenna.radiowaves.left.and.right")
          }.tag(SettingsModel.SelectedSetting.radio.rawValue)
        
        NetworkView()
          .tabItem {
            Text(SettingsModel.SelectedSetting.network.rawValue)
            Image(systemName: "wifi")
          }.tag(SettingsModel.SelectedSetting.network.rawValue)
        
        GpsView()
          .tabItem {
            Text(SettingsModel.SelectedSetting.gps.rawValue)
            Image(systemName: "globe")
          }.tag(SettingsModel.SelectedSetting.gps.rawValue)
        
        TxView()
          .tabItem {
            Text(SettingsModel.SelectedSetting.tx.rawValue)
            Image(systemName: "bolt.horizontal")
          }.tag(SettingsModel.SelectedSetting.tx.rawValue)
        
        PhoneCwView()
          .tabItem {
            Text(SettingsModel.SelectedSetting.phoneCw.rawValue)
            Image(systemName: "mic")
          }.tag(SettingsModel.SelectedSetting.phoneCw.rawValue)
      }
      
      Group {
        XvtrView()
          .tabItem {
            Text(SettingsModel.SelectedSetting.xvtrs.rawValue)
            Image(systemName: "arrow.up.arrow.down.circle")
          }.tag(SettingsModel.SelectedSetting.xvtrs.rawValue)
        
        ProfilesView()
          .tabItem {
            Text(SettingsModel.SelectedSetting.profiles.rawValue)
            Image(systemName: "brain.head.profile")
          }.tag(SettingsModel.SelectedSetting.profiles.rawValue)
        
        ColorsView()
          .tabItem {
            Text(SettingsModel.SelectedSetting.colors.rawValue)
            Image(systemName: "eyedropper")
          }.tag(SettingsModel.SelectedSetting.colors.rawValue)
        
        
        MiscSettingsView()
          .tabItem {
            Text(SettingsModel.SelectedSetting.misc.rawValue)
            Image(systemName: "gear")
          }.tag(SettingsModel.SelectedSetting.misc.rawValue)
        
        ConnectionView()
          .tabItem {
            Text(SettingsModel.SelectedSetting.connection.rawValue)
            Image(systemName: "list.bullet")
          }.tag(SettingsModel.SelectedSetting.connection.rawValue)
      }
    }
    .onDisappear {
      // close the ColorPicker (if open)
      if NSColorPanel.shared.isVisible {
        NSColorPanel.shared.performClose(nil)
      }
    }
    .frame(width: 600, height: 350)
    .padding()
  }
}

#Preview {
  SettingsView()
    .frame(width: 600, height: 350)
    .padding()
}
