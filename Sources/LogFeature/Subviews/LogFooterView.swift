//
//  LogFooterView.swift
//  ViewComponents/LogView
//
//  Created by Douglas Adams on 1/8/22.
//

import ComposableArchitecture
import SwiftUI

// ----------------------------------------------------------------------------
// MARK: - View

struct LogFooter: View {
  let store: StoreOf<LogFeature>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack {
        Stepper("Font Size",
                value: viewStore.binding(
                  get: \.fontSize,
                  send: { value in .fontSizeStepper(value) }),
                in: 8...14)
        Text(String(format: "%2.0f", viewStore.fontSize)).frame(alignment: .leading)

        Spacer()
        
        HStack {
          Text("Go to \(viewStore.gotoLast ? "First" : "Last")")
          Image(systemName: viewStore.gotoLast ? "arrow.up.square" : "arrow.down.square").font(.title)
            .onTapGesture { viewStore.send(.toggle(\.gotoLast)) }
        }
         .frame(width: 120, alignment: .trailing)
        Spacer()
        
        HStack(spacing: 20) {
          Button("Refresh") { viewStore.send(.refresh) }
            .disabled(viewStore.logUrl == nil)
          Toggle("Auto Refresh", isOn: viewStore.binding(get: \.autoRefresh, send: .autoRefresh))
        }
        Spacer()
        
        HStack(spacing: 20) {
          Button("Load") { viewStore.send(.loadButton) }
          Button("Save") { viewStore.send(.saveButton) }
        }
        
        Spacer()
        Button("Clear") { viewStore.send(.clearButton) }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct LogFooter_Previews: PreviewProvider {
  static var previews: some View {
    LogHeader( store: Store(initialState: LogFeature.State(),
                            reducer: LogFeature() )
    )
    .frame(minWidth: 975)
  }
}
