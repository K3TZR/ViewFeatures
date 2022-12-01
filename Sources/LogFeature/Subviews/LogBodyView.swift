//
//  LogBodyView.swift
//  ViewComponents/LogView
//
//  Created by Douglas Adams on 1/8/22.
//

import ComposableArchitecture
import SwiftUI

// ----------------------------------------------------------------------------
// MARK: - View

struct LogBodyView: View {
  let store: StoreOf<LogFeature>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ScrollViewReader { proxy in
        ScrollView([.horizontal, .vertical]) {
          VStack(alignment: .leading) {
            ForEach( viewStore.filteredLines) { message in
              Text(message.text)
                .font(.system(size: viewStore.fontSize, weight: .regular, design: .monospaced))
                .foregroundColor(message.color)
                .textSelection(.enabled)
            }
            .onChange(of: viewStore.gotoLast, perform: { _ in
              if viewStore.filteredLines.count > 0 {
                let id = viewStore.gotoLast ? viewStore.filteredLines.last!.id : viewStore.filteredLines.first!.id
                proxy.scrollTo(id, anchor: .bottomLeading)
              }
            })
            .onChange(of: viewStore.filteredLines.count, perform: { _ in
              if viewStore.filteredLines.count > 0 {
                let id = viewStore.gotoLast ? viewStore.filteredLines.last!.id : viewStore.filteredLines.first!.id
                proxy.scrollTo(id, anchor: .bottomLeading)
              }
            })
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct LogBodyView_Previews: PreviewProvider {
  static var previews: some View {
    LogHeader( store: Store(initialState: LogFeature.State(),
                            reducer: LogFeature() )
    )
      .frame(minWidth: 975, minHeight: 400)
      .padding()
  }
}
