import SwiftUI

struct EmptyView: View {
  
  var text: String
  
  var body: some View {
    VStack {
      Image("empty")
      Text(text)
    }
  }
}
