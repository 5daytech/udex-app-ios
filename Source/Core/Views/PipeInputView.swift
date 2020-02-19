import SwiftUI

struct PipeInputView: View {
  var isPipeShowing: Bool
  var text: String?
  
  @State var dim = false
  
  var body: some View {
    HStack {
      Text(text ?? "0.00")
        .foregroundColor(text != nil ? Color("T1") : Color("T2"))
        .lineLimit(1)
      if isPipeShowing {
        Text("|")
          .offset(x: -9)
          .opacity(dim ? 0 : 1.0)
          .animation(
            Animation
              .linear(duration: 0.5)
              .repeatForever()
          )
          .onAppear {
            self.dim.toggle()
          }
      }
    }
  }
}
