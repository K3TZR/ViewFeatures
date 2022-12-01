//
//  LogCore.swift
//  ViewComponents/LogView
//
//  Created by Douglas Adams on 11/30/21.
//

import ComposableArchitecture
import SwiftUI

import Shared

public struct LogFeature: ReducerProtocol {

  public init() {}
  
  public struct State: Equatable {
    
    public init() {}

    public var autoRefresh = false
    public var filter: LogFilter = .none
    public var filteredLines = [LogLine]()
    public var filterText: String =  ""
    public var fontSize: CGFloat = 12.0
    public var gotoLast = true
    public var level: LogLevel = .debug
    public var lines = [LogLine]()
    public var logUrl: URL?
    public var showTimestamps = false
    public var url: URL? = nil
  }
  
  public enum Action: Equatable {
    case onAppear
    
    case autoRefresh
    case clearButton
    case filterTextField(String)
    case filterPicker(LogFilter)
    case fontSizeStepper(CGFloat)
    case levelPicker(LogLevel)
    case loadButton
    case refresh
    case saveButton
    case showTimestamps
    case toggle(WritableKeyPath<LogFeature.State, Bool>)

    
    case refilter
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
      
    case .onAppear:
      let info = getBundleInfo()
      state.url = URL.appSupport.appendingPathComponent(info.domain + "." + info.appName + "/Logs/" + info.appName + ".log" )
      
      reload(&state)
      return .none

    case .autoRefresh:
      state.autoRefresh.toggle()
      return .none
      
    case .clearButton:
      state.filteredLines.removeAll()
      return .none
      
    case .loadButton:
      state.url = showOpenPanel()
      reload(&state)
      return .none

    case .filterPicker(let filter):
      state.filter = filter
      return Effect(value: .refilter)
      
    case .filterTextField(let text):
      state.filterText = text
      return Effect(value: .refilter)

    case .fontSizeStepper(let value):
      state.fontSize = value
      return .none

    case .levelPicker(let level):
      state.level = level
      return Effect(value: .refilter)

    case .refilter:
      state.filteredLines = filterLog(state.lines, state.filter, state.filterText, state.level, state.showTimestamps)
      return .none

    case .refresh:
      return .none

    case .saveButton:
      if let saveURL = showSavePanel() {
        let textArray = state.filteredLines.map { $0.text }
        let fileTextArray = textArray.joined(separator: "\n")
        try? fileTextArray.write(to: saveURL, atomically: true, encoding: .utf8)
      }
      return .none

    case .showTimestamps:
      state.showTimestamps.toggle()
      return Effect(value: .refilter)

    case .toggle(let keyPath):
      // handles all buttons with a Bool state, EXCEPT LoginRequiredButton and audioCheckbox
      state[keyPath: keyPath].toggle()
      return .none
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Helper functions

private func getBundleInfo() -> (domain: String, appName: String) {
  let bundleIdentifier = Bundle.main.bundleIdentifier ?? "net.k3tzr.LogView"
  let separator = bundleIdentifier.lastIndex(of: ".")!
  let appName = String(bundleIdentifier.suffix(from: bundleIdentifier.index(separator, offsetBy: 1)))
  let domain = String(bundleIdentifier.prefix(upTo: separator))
  return (domain, appName)
}

private func reload(_ state: inout LogFeature.State ) {
  if state.url == nil {
    fatalError("Unable to read Log file")
  } else {
    state.lines.removeAll()
    readLogFile(at: state.url!, lines: &state.lines)
    state.filteredLines = filterLog(state.lines, state.filter, state.filterText, state.level, state.showTimestamps)
  }
}

private func readLogFile(at url: URL, lines: inout [LogLine]) {
  /// Determine the color to assign to a Log entry
  /// - Parameter text:     the entry
  /// - Returns:            a Color
  func logLineColor(_ text: String) -> Color {
    if text.contains("[Debug]") { return .gray }
    else if text.contains("[Info]") { return .primary }
    else if text.contains("[Warning]") { return .orange }
    else if text.contains("[Error]") { return .red }
    else { return .primary }
  }

  do {
    // get the contents of the file
    let logString = try String(contentsOf: url, encoding: .ascii)
    // parse it into lines
    let entries = logString.components(separatedBy: "\n").dropLast()
    for entry in entries {
      lines.append(LogLine(text: entry, color: logLineColor(entry)))
    }
    
  } catch {
    fatalError("Unable to read Log file")
  }
}

/// Filter an array of Log entries
/// - Parameters:
///   - messages:       the array
///   - level:          a log level
///   - filter:         a filter type
///   - filterText:     the filter text
///   - showTimes:      whether to show timestamps
/// - Returns:          the filtered array of Log entries
private func filterLog(_ lines: [LogLine], _ filter: LogFilter, _ filterText: String, _ level: LogLevel, _ showTimeStamps: Bool = true) -> [LogLine] {
  var filteredLines = [LogLine]()
  
  // filter the log entries
  switch level {
  case .debug:     filteredLines = lines
  case .info:      filteredLines = lines.filter { $0.text.contains(" [Error] ") || $0.text.contains(" [Warning] ") || $0.text.contains(" [Info] ") }
  case .warning:   filteredLines = lines.filter { $0.text.contains(" [Error] ") || $0.text.contains(" [Warning] ") }
  case .error:     filteredLines = lines.filter { $0.text.contains(" [Error] ") }
  }
  
  switch filter {
  case .prefix:       filteredLines = filteredLines.filter { $0.text.contains(" > " + filterText) }
  case .includes:     filteredLines = filteredLines.filter { $0.text.contains(filterText) }
  case .excludes:     filteredLines = filteredLines.filter { !$0.text.contains(filterText) }
  case .none:         break
  }
  
  if !showTimeStamps {
    for (i, line) in filteredLines.enumerated() {
      filteredLines[i].text = String(line.text.suffix(from: line.text.firstIndex(of: "[") ?? line.text.startIndex))
    }
  }
  return filteredLines
}

/// Display a SavePanel
/// - Returns:       the URL of the selected file or nil
private func showSavePanel() -> URL? {
  let savePanel = NSSavePanel()
  //    savePanel.allowedContentTypes = [.text]
  savePanel.nameFieldStringValue = "Api6000Tester-C.log"
  savePanel.canCreateDirectories = true
  savePanel.isExtensionHidden = false
  savePanel.allowsOtherFileTypes = false
  savePanel.title = "Save the Log"
  
  let response = savePanel.runModal()
  return response == .OK ? savePanel.url : nil
}

/// Display an OpenPanel
/// - Returns:        the URL of the selected file or nil
private func showOpenPanel() -> URL? {
  let openPanel = NSOpenPanel()
  openPanel.allowedContentTypes = [.text]
  openPanel.allowsMultipleSelection = false
  openPanel.canChooseDirectories = false
  openPanel.canChooseFiles = true
  openPanel.title = "Open an existing Log"
  let response = openPanel.runModal()
  return response == .OK ? openPanel.url : nil
}


// ----------------------------------------------------------------------------
// MARK: - Structs and Enums

public struct LogLine: Identifiable, Equatable {
  public var id = UUID()
  var text: String
  var color: Color

  public init(text: String, color: Color = .primary) {
    self.text = text
    self.color = color
  }
}

public enum LogFilter: String, CaseIterable {
  case none
  case includes
  case excludes
  case prefix
}

