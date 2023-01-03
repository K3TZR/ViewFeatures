//
//  RadioSettingsCore.swift
//  
//
//  Created by Douglas Adams on 12/31/22.
//

import Foundation
import ComposableArchitecture

import Objects
import Shared

public struct RadioSettingsFeature: ReducerProtocol {
  
  public init() {}
  
  @Dependency(\.apiModel) var apiModel
  
  public struct State: Equatable {
    public init
    (
    )
    {
    }
  }
  
  public enum Action: Equatable {
    case binauralRxButton
    case calibrateButton
    case calibrationError(Int)
    case calibrationFrequency(Int)
    case callsign(String)
    case flexControlButton
    case muteLocalAudioButton
    case nickname(String)
    case region(String)
    case remoteOnButton
    case screenSaver(String)
    case singleClickButton
    case sliceMinimizedButton
    case snapTuneButton
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {

    case .binauralRxButton:
      return .run { _ in
        await apiModel.radio?.parseAndSend(.binauralRxEnabled)
      }

    case .calibrateButton:
      return .run { _ in
        await apiModel.radio?.radioCalibrateCmd()
      }

    case .calibrationError(let frequency):
      return .run { _ in
        await apiModel.radio?.parseAndSend(.freqErrorPpb, String(frequency))
      }

    case .calibrationFrequency(let frequency):
      return .run { _ in
        await apiModel.radio?.parseAndSend(.calFreq, String(frequency))
      }

    case .callsign(let callsign):
      return .run { _ in
        await apiModel.radio?.parseAndSend(Radio.InfoProperty.callsign, callsign)
      }

    case .flexControlButton:
      return .run { _ in
        await apiModel.radio?.parseAndSend(.flexControlEnabled)
      }

    case .muteLocalAudioButton:
      return .run { _ in
        await apiModel.radio?.parseAndSend(.muteLocalAudio)
      }

    case .nickname(let nickname):
      return .run { _ in
        await apiModel.radio?.parseAndSend(.nickname, nickname)
      }

    case .region(let region):
      return .run { _ in
        await apiModel.radio?.parseAndSend(.region, region)
      }

    case .remoteOnButton:
      return .run { _ in
        await apiModel.radio?.parseAndSend(.remoteOnEnabled)
      }

    case .screenSaver(let screenSaver):
      return .run { _ in
        await apiModel.radio?.parseAndSend(.screensaver, screenSaver)
      }

    case .singleClickButton:
//      return .run { _ in
//        await apiModel.transmit.parseAndSend(.cwSwapPaddles)
//      }
      return .none

    case .sliceMinimizedButton:
//      return .run { _ in
//        await apiModel.transmit.parseAndSend(.cwSwapPaddles)
//      }
      return .none

    case .snapTuneButton:
      return .run { _ in
        await apiModel.radio?.parseAndSend(.snapTuneEnabled)
      }
    }
  }
}
