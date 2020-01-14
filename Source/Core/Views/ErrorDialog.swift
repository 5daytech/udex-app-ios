//
//  ErrorDialog.swift
//  UDEX
//
//  Created by Abai Abakirov on 1/13/20.
//  Copyright © 2020 MakeUseOf. All rights reserved.
//

import SwiftUI

struct ErrorDialog: View {
  
  var message: String
  var onClose: () -> Void
  
  var body: some View {
    VStack {
      Text(message)
        .padding(16)
        .foregroundColor(Color("T1"))
      
      Button(action: {
        self.onClose()
      }) {
        Spacer()
        Text("CLOSE")
          .font(.system(size: 14, weight: .bold))
          .padding([.top, .bottom], 10)
        Spacer()
      }
      .background(Color("main"))
      .foregroundColor(Color("background"))
    }
    
  }
}

struct ErrorDialog_Previews: PreviewProvider {
  static var previews: some View {
    ErrorDialog(message: "Error", onClose: {})
  }
}
