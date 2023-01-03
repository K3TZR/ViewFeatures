//
//  ProfilesSettingsCore.swift
//  
//
//  Created by Douglas Adams on 12/31/22.
//

import Foundation
import ComposableArchitecture
import SwiftUI

import Objects
import Shared

public struct ProfilesSettingsFeature: ReducerProtocol {
  
  public init() {}
  
  @AppStorage("selectedProfileType") var selectedProfileType: ProfileType = .mic
  @Dependency(\.apiModel) var apiModel
  
  public struct State: Equatable {
    
    public init
    (
    )
    {
    }
  }
  
  public enum Action: Equatable {
    case create(String, String)
    case delete(String, UUID)
    case reset(String, UUID)
    case load(String, UUID)
    case selectedType(ProfileType)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    
    switch action {
    
    case .create(let profileType, let profileName):
      return .run { _ in
        await apiModel.profileCreate(profileType, profileName)
      }

    case .delete(let profileType, let profileNameId):
      return .run { _ in
        await apiModel.profileDelete(profileType, profileNameId)
      }

    case .reset(let profileType, let profileNameId):
      return .run { _ in
        await apiModel.profileDelete(profileType, profileNameId)
      }

    case .load(let profileType, let profileNameId):
      print("select, type = \(profileType), id = \(profileNameId)")
      return .run { _ in
        await apiModel.profileLoad(profileType, profileNameId)
      }
      
    case .selectedType(let type):
      selectedProfileType = type
      return .none
    }
  }
}
