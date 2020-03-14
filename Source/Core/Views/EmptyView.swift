import SwiftUI

struct EmptyView: View {
  
  var text: String
  
  var body: some View {
    VStack {
      Image("empty")
      Text(text)
        .font(.custom(Constants.Fonts.regular, size: 18))
    }
  }
}
