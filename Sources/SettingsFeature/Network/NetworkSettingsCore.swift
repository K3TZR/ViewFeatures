//
//  File.swift
//  
//
//  Created by Douglas Adams on 12/31/22.
//

import Foundation
import ComposableArchitecture

import Objects
import Shared

public struct NetworkSettingsFeature: ReducerProtocol {
  
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
    case enforcePrivateIpButton
    case addressType(String)
    case applyStaticButton
    case staticIp(String)
    case staticMask(String)
    case staticGateway(String)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {

    case .addressType(let type):
      return .run { _ in
        if type == "DHCP" {
          await apiModel.radio?.radioDhcpCmd()
        } else {
          await apiModel.radio?.radioStaticCmd()
        }
      }

    case .applyStaticButton:
      return .run { _ in
        await apiModel.radio?.radioStaticCmd()
      }

    case .enforcePrivateIpButton:
      return .run { _ in
        await apiModel.radio?.setAndSend(.enforcePrivateIpEnabled)
      }

    case .staticIp(let ip):
      return .run { _ in
        await apiModel.radio?.setAndSend(Radio.StaticNetProperty.ip, ip)
      }
      
    case .staticMask(let mask):
      return .run { _ in
        await apiModel.radio?.setAndSend(Radio.StaticNetProperty.mask, mask)
      }
      
    case .staticGateway(let gateway):
      return .run { _ in
        await apiModel.radio?.setAndSend(Radio.StaticNetProperty.gateway, gateway)
      }
    }
  }
}
