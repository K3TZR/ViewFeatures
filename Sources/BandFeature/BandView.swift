//
//  BandView.swift
//  
//
//  Created by Douglas Adams on 12/20/22.
//

import SwiftUI

public struct BandView: View {
  
  public init() {}
  
  public var body: some View {
    
    Grid(alignment: .leading, horizontalSpacing: 2, verticalSpacing: 5) {
      
      GridRow(alignment: .center) {
        Button(action: {}) { Text("160").frame(width: 35) }
        Button(action: {}) { Text("80").frame(width: 35) }
        Button(action: {}) { Text("60").frame(width: 35) }
      }
      GridRow(alignment: .center)  {
        Button(action: {}) { Text("40").frame(width: 35) }
        Button(action: {}) { Text("30").frame(width: 35) }
        Button(action: {}) { Text("20").frame(width: 35) }
      }
      GridRow(alignment: .center)  {
        Button(action: {}) { Text("17").frame(width: 35) }
        Button(action: {}) { Text("15").frame(width: 35) }
        Button(action: {}) { Text("12").frame(width: 35) }
      }
      GridRow (alignment: .center) {
        Button(action: {}) { Text("10").frame(width: 35) }
        Button(action: {}) { Text("6").frame(width: 35) }
        Button(action: {}) { Text("4").frame(width: 35) }
      }
      GridRow(alignment: .center)  {
        Button(action: {}) { Text("").frame(width: 35) }
        Button(action: {}) { Text("WWV").frame(width: 35) }
        Button(action: {}) { Text("GEN").frame(width: 35) }
      }
      GridRow(alignment: .center)  {
        Button(action: {}) { Text("2200").frame(width: 35) }
        Button(action: {}) { Text("6300").frame(width: 35) }
        Button(action: {}) { Text("XVTR").frame(width: 35) }
      }
    }
    .frame(width: 160)
    .padding(5)
  }
}

struct BandView_Previews: PreviewProvider {
    static var previews: some View {
        BandView()
    }
}
