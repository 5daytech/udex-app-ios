import SwiftUI

struct PinView: View {
  var title: String = "Passcode"
  @ObservedObject var viewModel: PinViewModel
  var onValidate: (() -> Void)? = nil
  var onSuccess: (() -> Void)? = nil
  
  @State var attemts: Int = 0
  
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  var body: some View {
    VStack {
      Spacer()
      Text(viewModel.title ?? title)
      HStack {
        ForEach(viewModel.numbers, id: \.self) { (number) -> Image in
          if number == nil {
            return Image("pin_empty")
          } else {
            return Image("pin_entered")
          }
        }
      }
      .modifier(Shake(animatableData: CGFloat(attemts)))
      
      Spacer()
      NumberPad { (number) in
        self.viewModel.inputNumber(number, self.onValidate, onSuccessPasscode: {
          self.onSuccess?()
          self.presentationMode.wrappedValue.dismiss()
        }, onFail: {
          withAnimation {
            self.attemts += 1
          }
        })
      }
    }
    .onAppear {
      self.viewModel.onAppear()
    }
  }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
