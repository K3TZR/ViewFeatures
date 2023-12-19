//
//  LoginView.swift
//  ViewFeatures/LoginFeature
//
//  Created by Douglas Adams on 12/28/21.
//

import SwiftUI

// ----------------------------------------------------------------------------
// MARK: - View(s)

public struct LoginView: View {
  var user: Binding<String>
  var pwd: Binding<String>
  var heading: String
  var message: String?
  var userLabel: String
  var pwdLabel: String
  var labelWidth: CGFloat
  var overallWidth: CGFloat
  
  public init
  (
    user: Binding<String>,
    pwd: Binding<String>,
    heading: String = "Please Login",
    message: String? = nil,
    userLabel: String = "User",
    pwdLabel: String = "Password",
    labelWidth: CGFloat = 100,
    overallWidth: CGFloat = 350
  )
  {
    self.user = user
    self.pwd = pwd
    self.heading = heading
    self.message = message
    self.userLabel = userLabel
    self.pwdLabel = pwdLabel
    self.labelWidth = labelWidth
    self.overallWidth = overallWidth
  }

  @Environment(\.presentationMode) var presentationMode

  public var body: some View {
    VStack(spacing: 10) {
      Text( heading ).font( .title2 )
      if message != nil { Text(message!).font(.subheadline) }
      Divider()
      HStack {
        Text( userLabel ).frame( width: labelWidth, alignment: .leading)
        TextField( "", text: user)
      }
      HStack {
        Text( pwdLabel ).frame( width: labelWidth, alignment: .leading)
        SecureField( "", text: pwd)
      }
      
      HStack( spacing: 60 ) {
        Button( "Cancel" ) {
          user.wrappedValue = ""
          pwd.wrappedValue = ""
          presentationMode.wrappedValue.dismiss()
        }
          .keyboardShortcut( .cancelAction )
        
        Button( "Log in" ) { presentationMode.wrappedValue.dismiss() }
          .keyboardShortcut( .defaultAction )
          .disabled( user.wrappedValue.isEmpty || pwd.wrappedValue.isEmpty )
      }
    }
    .frame( minWidth: overallWidth )
    .padding(10)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview(s)

#Preview {
  LoginView(user: .constant("SomeUser"), pwd: .constant("A Password"))
    .frame( width: 350 )
    .padding(10)
}
