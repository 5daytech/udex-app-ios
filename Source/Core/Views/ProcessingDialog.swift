import SwiftUI

struct ProcessingDialog: View {
  
  @State var progressBarValue: CGFloat = 0
  
  var body: some View {
    VStack(spacing: 20) {
      Text("Processing...")
      .foregroundColor(Color("T1"))
      .font(Font.system(size: 18, weight: .bold, design: .default))
      ProgressBar(value: $progressBarValue)
      .cornerRadius(5)
      .frame(height: 10)
      Text("Time remaining: \(60 - Int(progressBarValue))s")
      .foregroundColor(Color("T3"))
      .font(Font.system(size: 14))
    }
    .padding()
    .background(Color("secondary_background"))
    .clipped()
    .shadow(radius: 5)
    .onAppear {
      Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
        self.progressBarValue += 0.1
        if (self.progressBarValue >= 59) {
          timer.invalidate()
        }
      }
    }
  }
}

struct ProcessingDialog_Previews: PreviewProvider {
  static var previews: some View {
    ProcessingDialog()
  }
}
