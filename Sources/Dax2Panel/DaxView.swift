//
//  DaxView.swift
//  
//
//  Created by Douglas Adams on 11/29/23.
//

import AVFoundation
import SwiftUI

import FlexApi
import Flag
import SettingsModel
import SharedModel

// ----------------------------------------------------------------------------
// MARK: - View

public struct DaxView: View {
  
  public init() {}
  
  @Environment(ApiModel.self) private var api
  @Environment(SettingsModel.self) private var settings
  
  @State var txIsOn = false
  @State var micIsOn = false
  @State var rxIsOn = true
  @State var iqIsOn = false
  
  @State var daxRxChannels = [1, 2, 3, 4]
  @State var daxIqChannels = [1, 2, 3, 4]

  private func toggleOption(_ option: SettingsModel.DaxPanelOptions) {
    if settings.daxPanelOptions.contains(option) {
      settings.daxPanelOptions.remove(option)
    } else {
      settings.daxPanelOptions.insert(option)
    }
  }
  
  public var body: some View {
    
    VStack(alignment: .center) {
      HStack {
        ControlGroup {
          Toggle("Tx", isOn: Binding(get: { settings.daxPanelOptions.contains(.tx) }, set: {_,_  in toggleOption(.tx) } ))
          Toggle("Mic", isOn: Binding(get: { settings.daxPanelOptions.contains(.mic)  }, set: {_,_  in toggleOption(.mic) } ))
          Toggle("Rx", isOn: Binding(get: { settings.daxPanelOptions.contains(.rx)  }, set: {_,_  in toggleOption(.rx) } ))
          Toggle("IQ", isOn: Binding(get: { settings.daxPanelOptions.contains(.iq)  }, set: {_,_  in toggleOption(.iq) } ))
        }
        .frame(width: 280)
      }

      Spacer()
      
      ScrollView {
        VStack(spacing: 20) {
          if settings.daxPanelOptions.contains(.tx) { DaxTxView(devices: AudioDevice.getDevices()) }
          if settings.daxPanelOptions.contains(.mic) { DaxMicView(devices: AudioDevice.getDevices()) }
          if settings.daxPanelOptions.contains(.rx) { DaxRxView(devices: AudioDevice.getDevices()) }
//          if settings.daxPanelOptions.contains(.iq) { DaxIqView(devices: AudioDevice.getDevices()) }
        }
      }.scrollIndicators(.visible, axes: .vertical)
    }
    .frame(minWidth: 275, maxWidth: 275, minHeight: 180, maxHeight: .infinity)
    .padding(.horizontal, 10)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

#Preview {
  DaxView()
    .environment(ApiModel.shared)
    .environment(SettingsModel.shared)
    .frame(minWidth: 275, maxWidth: 275, minHeight: 120, maxHeight: .infinity)
    .padding()
}




//final public class AudioDevice {
//  var id: AudioDeviceID
//  
//  public init(_ id: AudioDeviceID, name: String? = nil) {
//    self.id = id
//  }
//  
//  var hasOutput: Bool {
//    get {
//      var address:AudioObjectPropertyAddress = AudioObjectPropertyAddress(
//        mSelector:AudioObjectPropertySelector(kAudioDevicePropertyStreamConfiguration),
//        mScope:AudioObjectPropertyScope(kAudioDevicePropertyScopeOutput),
//        mElement:0)
//      
//      var propsize: UInt32 = UInt32(MemoryLayout<CFString?>.size);
//      if AudioObjectGetPropertyDataSize(id, &address, 0, nil, &propsize) != 0 {
//        return false;
//      }
//      
//      let bufferList = UnsafeMutablePointer<AudioBufferList>.allocate(capacity:Int(propsize))
//      if AudioObjectGetPropertyData(id, &address, 0, nil, &propsize, bufferList) != 0 {
//        return false
//      }
//      
//      let buffers = UnsafeMutableAudioBufferListPointer(bufferList)
//      for bufferNum in 0..<buffers.count {
//        if buffers[bufferNum].mNumberChannels > 0 { return true }
//      }
//      return false
//    }
//  }
//  
//  var uid: String? {
//    get {
//      var address:AudioObjectPropertyAddress = AudioObjectPropertyAddress(
//        mSelector:AudioObjectPropertySelector(kAudioDevicePropertyDeviceUID),
//        mScope:AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
//        mElement:AudioObjectPropertyElement(kAudioObjectPropertyElementMain))
//      
//      var name: CFString? = nil
//      var propsize: UInt32 = UInt32(MemoryLayout<CFString?>.size)
//      guard AudioObjectGetPropertyData(id, &address, 0, nil, &propsize, &name) == 0 else { return nil }
//      return name as String?
//    }
//  }
//  
//  var name: String? {
//    get {
//      var address:AudioObjectPropertyAddress = AudioObjectPropertyAddress(
//        mSelector:AudioObjectPropertySelector(kAudioDevicePropertyDeviceNameCFString),
//        mScope:AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
//        mElement:AudioObjectPropertyElement(kAudioObjectPropertyElementMain))
//      
//      var name: CFString? = nil
//      var propsize: UInt32 = UInt32(MemoryLayout<CFString?>.size)
//      guard AudioObjectGetPropertyData(id, &address, 0, nil, &propsize, &name) == 0 else { return nil }
//      return name as String?
//    }
//  }
//
//  public class func getDevices() -> [AudioDevice] {
//    var devices = [AudioDevice]()
//    var propsize: UInt32 = 0
//    var address: AudioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector:AudioObjectPropertySelector(kAudioHardwarePropertyDevices),
//                                                                         mScope:AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
//                                                                         mElement:AudioObjectPropertyElement(kAudioObjectPropertyElementMain))
//    
//    if AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject), &address, UInt32(MemoryLayout<AudioObjectPropertyAddress>.size), nil, &propsize) != 0 {
//      return devices
//    }
//    var deviceIds = [AudioDeviceID](repeating: AudioDeviceID(0), count: Int(propsize / UInt32(MemoryLayout<AudioDeviceID>.size)))
//    if AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &propsize, &deviceIds) != 0 {
//      return devices
//    }
//    for deviceId in deviceIds {
//      devices.append(AudioDevice(deviceId))
//      print("----->>>>> ", AudioDevice(deviceId).id, AudioDevice(deviceId).name)
//    }
//    return devices
//  }

//  public class func setDefault(_ id: AudioDeviceID, for direction: AudioObjectPropertySelector) {
//    if direction == kAudioHardwarePropertyDefaultInputDevice {
//      print("Set default INPUT to deviceId = \(id)")
//    } else {
//      print("Set default OUTPUT to deviceId = \(id)")
//    }
//    
//    //    AudioUnitSetProperty(outputUnit,
//    //                         kAudioOutputUnitProperty_CurrentDevice,
//    //                         kAudioUnitScope_Global,
//    //                         0,
//    //                         &id,
//    //                         UInt32(MemoryLayout<AudioDeviceID>.size))
//  }
  
//  public class func getDefault(_ outputUnit: AudioUnit) -> AudioDeviceID {
//    var deviceId = AudioDeviceID(0)
//    
//    var deviceIdSize = UInt32(MemoryLayout<AudioDeviceID>.size)
//    AudioUnitGetProperty(outputUnit,
//                         kAudioOutputUnitProperty_CurrentDevice,
//                         kAudioUnitScope_Global,
//                         0,
//                         &deviceId,
//                         &deviceIdSize)
//    return deviceId
//  }
//}
