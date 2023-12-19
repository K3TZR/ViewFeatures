//
//  MonitorView.swift
//  
//
//  Created by Douglas Adams on 2/26/23.
//

import SwiftUI

import FlexApi

// ----------------------------------------------------------------------------
// MARK: - Views

public struct MonitorView: View {
  var meter: Meter
  var valueWidth: CGFloat
  var interval: TimeInterval
  var textColor: Color
  var unitsWidth: CGFloat
  public init(
    meter: Meter,
    valueWidth: CGFloat = 50.0,
    interval: TimeInterval = 1.0,
    textColor: Color = .blue,
    unitsWidth: CGFloat = 50.0
  )
  {
    self.meter = meter
    self.valueWidth = valueWidth
    self.interval = interval
    self.textColor = textColor
    self.unitsWidth = unitsWidth
  }
  

  func color(_ meter: Meter) -> Color {
    // determine the background color
    switch meter.value {
    case ...meter.low:                // < low
      return .yellow.opacity(0.7)
    case meter.high...:               // > high
      return .red.opacity(0.7)
    default:                          // between low & high
      return .green.opacity(0.7)
    }
  }
  
  @State var throttledValue: CGFloat = 0.0
  
  public var body: some View {
    HStack(spacing: 1) {
      Text(String(format: "%0.2f", meter.value))
        .foregroundColor(color(meter))
        .frame(width: valueWidth)
        .help(meter.name)

//      Text(String(format: "%0.2f", throttledValue))
//        .foregroundColor(color(meter))
//        .frame(width: valueWidth)
//        .help(meter.name)
//        .onReceive(meter.$value.throttle(for: RunLoop.SchedulerTimeType.Stride(interval), scheduler: RunLoop.main, latest: true)) { throttledValue = CGFloat($0) }
      Text(meter.units).foregroundColor(textColor)
        .frame(width: unitsWidth)
    }
    .border(.secondary)
  }
}

#Preview {
  MonitorView(meter: Meter(4))
}
