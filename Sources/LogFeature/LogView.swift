//
//  LogView.swift
//  ViewComponents/LogView
//
//  Created by Douglas Adams on 10/10/20.
//  Copyright © 2020-2021 Douglas Adams. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

// ----------------------------------------------------------------------------
// MARK: - View

/// A View to display the contents of the app's log
///
public struct LogView: View {  
  let store: StoreOf<LogFeature>
  
  public init(store: StoreOf<LogFeature>) {
    self.store = store
  }
  
  public var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        LogHeader(store: store)
        Divider().background(Color(.red))
        Spacer()
        LogBodyView(store: store)
        Spacer()
        Divider().background(Color(.red))
        LogFooter(store: store)
      }
      .onAppear( perform: { viewStore.send(.onAppear) })
    }
    .frame(minWidth: 700, maxWidth: .infinity, alignment: .leading)
    .padding(10)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct LogView_Previews: PreviewProvider {
  static var previews: some View {
    LogView(store: Store(initialState: LogFeature.State(),
                         reducer: LogFeature() )
    )
      .frame(minWidth: 975, minHeight: 400)
      .padding()
  }
}
