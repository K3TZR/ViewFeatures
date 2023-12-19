//
//  SwiftUIView.swift
//  
//
//  Created by Douglas Adams on 11/28/23.
//

import SwiftUI

public struct HeaderView: View {
  let title: String
  @Binding var showDetails: Bool
  
  public var body: some View {
    HStack {
      Text(title)
      Spacer()
    }
  }
}

#Preview {
  HeaderView(title: "Rx Streams", showDetails: .constant(true))
    .frame(width: 275)
}
