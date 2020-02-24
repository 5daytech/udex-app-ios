import SwiftUI

protocol NumberPadInputable {
  func inputNumber(_ number: String)
}

struct BottomCard<T: View>: View where T: NumberPadInputable {
  @Binding var showBottomCard: Bool
  var showNumberPad: Bool
  
  var content: T
  
  var body: some View {
    VStack(spacing: 32) {
      Button(action: {
        self.showBottomCard.toggle()
      }) {
        Spacer()
        Rectangle()
          .foregroundColor(Color.gray)
          .frame(width: 60, height: 6)
          .cornerRadius(3.0)
          .opacity(0.1)
          .padding(.top, 16)
        Spacer()
      }
      
      VStack(spacing: 32) {
        content
        if showNumberPad {
          NumberPad { (number) in
            self.content.inputNumber(number)
          }
        }
      }
      
      Spacer()
    }
    .background(Color("secondary_background"))
    .cornerRadius(30)
    .shadow(radius: 3)
  }
}
