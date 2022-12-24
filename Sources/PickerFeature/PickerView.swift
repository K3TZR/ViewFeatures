//
//  PickerView.swift
//
//  Created by Douglas Adams on 11/13/21.
//

import SwiftUI
import ComposableArchitecture

import Listener
import Shared

// ----------------------------------------------------------------------------
// MARK: - View(s)

public struct PickerView: View {
  let store: StoreOf<PickerFeature>

  @Dependency(\.listener) var listener
  
  public init(store: StoreOf<PickerFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading) {
        PickerHeaderView(isGui: viewStore.isGui)
        Divider()
        PickerBodyView(viewStore: viewStore, listener: listener)
        
        Spacer()
        Divider()
        PickerFooterView(viewStore: viewStore)
      }
    }
    .frame(minWidth: 600, minHeight: 250)
  }
}

struct PickerHeaderView: View {
  let isGui: Bool
  
  var body: some View {
    VStack {
      Text("Select a \(isGui ? "RADIO" : "STATION")")
        .font(.title)
        .padding(.bottom, 10)
      
      Text("Click on a \(isGui ? "RADIO" : "STATION") in the list below")
        .font(.title3)
        .padding(.bottom, 10)
      
      HStack(spacing: 0) {
        Group {
          Text("Type")
          Text("Name")
          Text("Status")
          Text("Station(s)")
        }
        .frame(width: 140, alignment: .leading)
      }
    }
    .font(.title2)
    .padding(.vertical, 10)
    .padding(.horizontal)
  }
}

public struct PickerBodyView: View {
  let viewStore: ViewStore<PickerFeature.State, PickerFeature.Action>
  @ObservedObject var listener: Listener
  
  public var body: some View {
    if viewStore.isGui {
      if listener.pickableRadios.count == 0 {
        Spacer()
        HStack {
          Spacer()
          Text("----------  NO Radios FOUND  ----------").foregroundColor(.red)
          Spacer()
        }
        Spacer()
      } else {
        PickerItemView(viewStore: viewStore, pickables: listener.pickableRadios)
      }

    } else {
      if listener.pickableStations.count == 0 {
        Spacer()
        HStack {
          Spacer()
          Text("----------  NO Stations FOUND  ----------").foregroundColor(.red)
          Spacer()
        }
        Spacer()
      } else {
        PickerItemView(viewStore: viewStore, pickables: listener.pickableStations)
      }
    }
  }
}

public struct PickerItemView: View {
  let viewStore: ViewStore<PickerFeature.State, PickerFeature.Action>
  let pickables: IdentifiedArrayOf<Pickable>
    
  func isSelected(_ selection: Pickable?, _ pickable: Pickable) -> Bool {
    
    selection?.packet.id == pickable.packet.id && selection?.packet.source == pickable.packet.source && selection?.station == pickable.station
  }
  
  func isDefault(_ pickable: Pickable, _ isGui: Bool, _ defaultValue: DefaultValue?) -> Bool {
    guard defaultValue != nil else { return false }
    if isGui {
      return pickable.packet.serial == defaultValue!.serial &&
      pickable.packet.source.rawValue == defaultValue!.source
    } else {
      return pickable.packet.serial == defaultValue!.serial &&
      pickable.packet.source.rawValue == defaultValue!.source &&
      pickable.station == defaultValue!.station
    }
  }
  
  public var body: some View {
    
    ForEach(pickables, id: \.id) { pickable in
      ZStack {
        HStack(spacing: 0) {
          Group {
            Text(pickable.packet.source.rawValue)
            Text(pickable.packet.nickname)
            Text(pickable.packet.status)
            Text(pickable.station)
          }
          .font(.title3)
          .frame(minWidth: 140, alignment: .leading)
          .foregroundColor(isDefault(pickable, viewStore.isGui, viewStore.defaultValue) ? .red : nil)
          .onTapGesture {
            viewStore.send(.selectionAction(pickable))
          }
        }
        Rectangle().fill(isSelected(viewStore.selection, pickable) ? .gray : .clear).frame(height: 20).opacity(0.2)
          .font(.title3)
          .frame(minWidth: 140, alignment: .leading)
      }
    }
    .padding(.horizontal)
  }
}

struct PickerFooterView: View {
  let viewStore: ViewStore<PickerFeature.State, PickerFeature.Action>
  
  var body: some View {
    
    HStack(){
      Button("Test") { viewStore.send(.testButton(viewStore.selection!)) }
        .disabled(viewStore.selection == nil || viewStore.selection!.packet.source == PacketSource.local)
      Circle()
        .fill(viewStore.testResult ? Color.green : Color.red)
        .frame(width: 20, height: 20)
      
      Spacer()
      Button("Default") { viewStore.send(.defaultButton(viewStore.selection!)) }
        .disabled(viewStore.selection == nil)
        .keyboardShortcut(.cancelAction)
      
      Spacer()
      Button("Cancel") { viewStore.send(.cancelButton) }
        .keyboardShortcut(.cancelAction)
      
      Spacer()
      Button("Connect") {
        viewStore.send(.connectButton(viewStore.selection!)) }
      .keyboardShortcut(.defaultAction)
      .disabled(viewStore.selection == nil)
    }
    .padding(.vertical, 10)
    .padding(.horizontal)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct PickerView_Previews: PreviewProvider {
  static var previews: some View {
    
    PickerView(store: Store(initialState: PickerFeature.State(isGui: true),
                            reducer: PickerFeature())
    )
    .previewDisplayName("Picker Gui")
    
    PickerView(store: Store(initialState: PickerFeature.State(isGui: false),
                            reducer: PickerFeature())
    )
    .previewDisplayName("Picker nonGui")
    
  }
}
