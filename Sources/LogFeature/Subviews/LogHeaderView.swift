//
//  SwiftUIView.swift
//  ViewComponents/LogView
//
//  Created by Douglas Adams on 1/8/22.
//

import ComposableArchitecture
import SwiftUI

import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct LogHeader: View {
  let store: StoreOf<LogFeature>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(spacing: 10) {
        Toggle("Show Timestamps", isOn: viewStore.binding(get: \.showTimestamps, send: .showTimestamps ))
        Spacer()
        
        Picker("Show Level", selection: viewStore.binding(
          get: \.level,
          send: { value in .levelPicker(value) } )) {
            ForEach(LogLevel.allCases, id: \.self) {
              Text($0.rawValue).tag($0)
            }
          }
          .pickerStyle(MenuPickerStyle())
        
        Spacer()
        
        Picker("Filter by", selection: viewStore.binding(
          get: \.filter,
          send: { value in .filterPicker(value) } )) {
            ForEach(LogFilter.allCases, id: \.self) {
              Text($0.rawValue).tag($0)
            }
          }
          .pickerStyle(MenuPickerStyle())

        Image(systemName: "x.circle").foregroundColor(viewStore.filterText == "" ? .gray : nil)
          .onTapGesture { viewStore.send(.filterTextField("")) }
        TextField("Filter text", text: viewStore.binding(
          get: \.filterText,
          send: { value in LogFeature.Action.filterTextField(value) }))
          .frame(maxWidth: 300, alignment: .leading)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct LogHeader_Previews: PreviewProvider {
  static var previews: some View {
    LogHeader( store: Store(initialState: LogFeature.State(),
                            reducer: LogFeature() )
    )
      .frame(minWidth: 975)
  }
}
