//
//  LogView.swift
//  ViewComponents/LogView
//
//  Created by Douglas Adams on 10/10/20.
//  Copyright © 2020-2021 Douglas Adams. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

import Shared

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
        LogHeader(viewStore: viewStore)
        Divider().background(Color(.red))
        Spacer()
        LogBodyView(viewStore: viewStore)
        Spacer()
        Divider().background(Color(.red))
        LogFooter(viewStore: viewStore)
      }
      .onAppear( perform: { viewStore.send(.onAppear) })
    }
    .frame(minWidth: 700, maxWidth: .infinity, alignment: .leading)
    .padding(10)
  }
}

struct LogHeader: View {
  let viewStore: ViewStore<LogFeature.State, LogFeature.Action>
  
  var body: some View {
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

struct LogBodyView: View {
  let viewStore: ViewStore<LogFeature.State, LogFeature.Action>
  
  var body: some View {
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

struct LogFooter: View {
  let viewStore: ViewStore<LogFeature.State, LogFeature.Action>
  
  var body: some View {
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
