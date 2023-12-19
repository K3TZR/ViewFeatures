//
//  AudioView.swift
//  
//
//  Created by Douglas Adams on 12/16/23.
//

import AVFoundation
import IdentifiedCollections
import SwiftUI

import FlexApi
import RxAVAudioPlayer
import SettingsModel
import SharedModel

public struct AudioView: View {
  
  public init() {}
  
  @Environment(ApiModel.self) private var api
  @Environment(RxAVAudioPlayer.self) private var rxAVAudioPlayer
  @Environment(SettingsModel.self) private var settings
  
  private var devices: [AudioDeviceID] {
    var propsize:UInt32 = 0
    var address:AudioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector:AudioObjectPropertySelector(kAudioHardwarePropertyDevices),
                                                                        mScope:AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
                                                                        mElement:AudioObjectPropertyElement(kAudioObjectPropertyElementMain))
    
    if AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject), &address, UInt32(MemoryLayout<AudioObjectPropertyAddress>.size), nil, &propsize) != 0 {
      return [AudioDeviceID]()
    }
    var deviceIds = [AudioDeviceID](repeating: AudioDeviceID(0), count: Int(propsize / UInt32(MemoryLayout<AudioDeviceID>.size)))
    if AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &propsize, &deviceIds) != 0 {
      return [AudioDeviceID]()
    }
    return deviceIds
  }
  
  public var body: some View {
    @Bindable var settingsBindable = settings
    
    GroupBox(label: Text("Mac Audio")) {
      Grid(alignment: .leading) {
        GridRow {
          Text("Enable for:")
          ControlGroup {
            Toggle("Transmit", isOn: $settingsBindable.remoteTxAudioEnabled).disabled(settings.remoteTxAudioInputDeviceId == 0)
            Toggle("Receive", isOn: $settingsBindable.remoteRxAudioEnabled).disabled(settings.remoteRxAudioOutputDeviceId == 0)
          }
            .frame(width: 130)
        }
        
        GridRow {
          Text("Input:").frame(width: 60, alignment: .leading)
          Picker("", selection: $settingsBindable.remoteTxAudioInputDeviceId) {
            Text("none selected").tag(0)
            ForEach(devices, id: \.self) { deviceId in
              if !AudioDevice(deviceId).hasOutput { Text(AudioDevice(deviceId).name!).tag(Int(deviceId)) }
            }
          }
          .pickerStyle(MenuPickerStyle())
          .labelsHidden()
        }

        GridRow {
          Text("Output:").frame(width: 60, alignment: .leading)
          Picker("", selection: $settingsBindable.remoteRxAudioOutputDeviceId) {
            Text("none selected").tag(0)
            ForEach(devices, id: \.self) { deviceId in
              if AudioDevice(deviceId).hasOutput { Text(AudioDevice(deviceId).name!).tag(Int(deviceId)) }
            }
          }
          .pickerStyle(MenuPickerStyle())
          .labelsHidden()
        }
      }
    }
    .frame(width: 300)
    .padding()
  }
}

//#Preview {
//  AudioView(rxAVAudioPlayer: RxAVAudioPlayer())
//    .environment(SettingsModel.shared)
//}


/*
 public func rxAudioVolume(_ volume: Float) {
   _rxAVAudioPlayer?.volume(volume)
 }
 
 public func rxAudioMute(_ enabled: Bool) {
   _rxAVAudioPlayer?.mute(enabled)
 }
 
 public func rxAudioDeviceID(_ deviceID: AudioDeviceID) {
   _rxAVAudioPlayer?.setOutputDevice(deviceID)
 }

 */
