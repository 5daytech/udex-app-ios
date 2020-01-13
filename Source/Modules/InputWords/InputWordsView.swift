//
//  InputWordsView.swift
//  UDEX
//
//  Created by Abai Abakirov on 1/10/20.
//  Copyright © 2020 MakeUseOf. All rights reserved.
//

import SwiftUI

struct InputWordsView: View {
  
  @State var words: String = ""
  
  var onInputWords: (String) -> Void
  
  var body: some View {
    VStack {
      TextField("Words separated via space", text: $words)
      Button(action: {
        self.onInputWords(self.words)
      }) {
        Text("Login")
      }
    }
  }
}

struct InputWordsView_Previews: PreviewProvider {
  static var previews: some View {
    InputWordsView(onInputWords: { _ in })
  }
}
