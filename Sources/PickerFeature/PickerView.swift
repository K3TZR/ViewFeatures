//
//  PickerView.swift
//
//  Created by Douglas Adams on 11/13/21.
//

import SwiftUI
import ComposableArchitecture

import Shared

// ----------------------------------------------------------------------------
// MARK: - View(s)

public struct PickerView: View {
  let store: StoreOf<PickerFeature>
  
  public init(store: StoreOf<PickerFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading) {
        PickerHeaderView(isGui: viewStore.isGui)
        Divider()
        if viewStore.pickables.count == 0 {
          Spacer()
          HStack {
            Spacer()
            Text("----------  NO  \(viewStore.isGui ? "Radio" : "Station")s  FOUND  ----------").foregroundColor(.red)
            Spacer()
          }
          Spacer()
        } else {
          PickerBodyView(store: store)
        }
        Spacer()
        Divider()
        PickerFooterView(store: store)
      }
    }
    .frame(minWidth: 600, minHeight: 250)
  }
}

public struct PickerBodyView: View {
  let store: StoreOf<PickerFeature>
  
  func isSelected(_ selection: Pickable?, _ pickable: Pickable) -> Bool {
    
    selection?.packet.id == pickable.packet.id && selection?.packet.source == pickable.packet.source && selection?.station == pickable.station
  }
  
  public var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ForEach(viewStore.pickables, id: \.id) { pickable in
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
            .foregroundColor(pickable.isDefault ? .red : nil)
            .onTapGesture {
              viewStore.send(.selectionAction(pickable))
            }
          }
          Rectangle().fill(isSelected(viewStore.selection, pickable) ? .gray : .clear).frame(height: 20).opacity(0.2)
            .font(.title3)
            .frame(minWidth: 140, alignment: .leading)
        }
      }
    }
    .padding(.horizontal)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct PickerView_Previews: PreviewProvider {
  static var previews: some View {

    PickerView(store: Store(initialState: PickerFeature.State(pickables: IdentifiedArrayOf<Pickable>(), isGui: true),
                            reducer: PickerFeature())
    )
    .previewDisplayName("Picker Gui (empty)")
    
//    PickerView(store: Store(initialState: PickerFeature.State(pickables: [
//      Pickable(id: UUID(), packetId: UUID(), source: PacketSource.local.rawValue, nickname: "Dougs 6500", status: "Available", serial: "1234-5678"),
//      Pickable(id: UUID(), packetId: UUID(), source: PacketSource.local.rawValue, nickname: "Petes 6300", status: "Available", serial: "1234-5678"),
//      Pickable(id: UUID(), packetId: UUID(), source: PacketSource.local.rawValue, nickname: "Dougs 6700", status: "Available", serial: "1234-5678"),
//      Pickable(id: UUID(), packetId: UUID(), source: PacketSource.local.rawValue, nickname: "Petes 6500", status: "Available", serial: "1234-5678")
//    ], isGui: true),
//                            reducer: PickerFeature())
//    )
//    .previewDisplayName("Picker Gui")
    
    PickerView(store: Store(initialState: PickerFeature.State(pickables: IdentifiedArrayOf<Pickable>(), isGui: false),
                            reducer: PickerFeature())
    )
    .previewDisplayName("Picker non Gui (empty)")
    
//    PickerView(store: Store(initialState: PickerState(pickables: [
//      Pickable(id: UUID(), packetId: UUID(), source: PacketSource.local.rawValue, nickname: "Dougs 6500", status: "InUse", station: "iPad", serial: "1234-5678"),
//      Pickable(id: UUID(), packetId: UUID(), source: PacketSource.local.rawValue, nickname: "Dougs 6500", status: "InUse", station: "Windows", serial: "1234-5678"),
//      Pickable(id: UUID(), packetId: UUID(), source: PacketSource.local.rawValue, nickname: "Petes 6500", status: "Available", station: "Windows", serial: "1234-5678"),
//    ],isGui: false),
//                            reducer: pickerReducer,
//                            environment: PickerEnvironment())
//    )
//    .previewDisplayName("Picker non Gui")
  }
}
