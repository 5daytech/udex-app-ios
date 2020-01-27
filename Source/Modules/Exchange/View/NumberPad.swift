import SwiftUI

struct NumberPad: View {
  
  var mainTitle: String
  var onNumberPressed: (String) -> Void
  var onMainPressed: () -> Void
  
  var body: some View {
    VStack(spacing: 30) {
      HStack {
        VStack(alignment: .center, spacing: 40) {
          Button(action: {
            self.onNumberPressed("1")
          }) {
            Text("1")
              .font(.system(size: 25))
              .foregroundColor(Color("T1"))
          }
          Button(action: {
            self.onNumberPressed("4")
          }) {
            Text("4")
              .font(.system(size: 25))
              .foregroundColor(Color("T1"))
          }
          Button(action: {
            self.onNumberPressed("7")
          }) {
            Text("7")
              .font(.system(size: 25))
              .foregroundColor(Color("T1"))
          }
          Button(action: {
            self.onNumberPressed(".")
          }) {
            Text(".")
              .font(.system(size: 25))
              .foregroundColor(Color("T1"))
          }
        }
        Spacer()
        VStack(alignment: .center, spacing: 40) {
          Button(action: {
            self.onNumberPressed("2")
          }) {
            Text("2")
              .font(.system(size: 25))
              .foregroundColor(Color("T1"))
          }
          Button(action: {
            self.onNumberPressed("5")
          }) {
            Text("5")
              .font(.system(size: 25))
              .foregroundColor(Color("T1"))
          }
          Button(action: {
            self.onNumberPressed("8")
          }) {
            Text("8")
              .font(.system(size: 25))
              .foregroundColor(Color("T1"))
          }
          Button(action: {
            self.onNumberPressed("0")
          }) {
            Text("0")
              .font(.system(size: 25))
              .foregroundColor(Color("T1"))
          }
        }
        Spacer()
        VStack(alignment: .center, spacing: 40) {
          Button(action: {
            self.onNumberPressed("3")
          }) {
            Text("3")
              .font(.system(size: 25))
              .foregroundColor(Color("T1"))
          }
          Button(action: {
            self.onNumberPressed("6")
          }) {
            Text("6")
              .font(.system(size: 25))
              .foregroundColor(Color("T1"))
          }
          Button(action: {
            self.onNumberPressed("9")
          }) {
            Text("9")
              .font(.system(size: 25))
              .foregroundColor(Color("T1"))
          }
          Button(action: {
            self.onNumberPressed("d")
          }) {
            Image("delete").renderingMode(.original)
          }
        }
      }
      .padding(EdgeInsets(
        top: 0,
        leading: 50,
        bottom: 0,
        trailing: 50
      ))
      Button(action: {
        self.onMainPressed()
      }) {
        Spacer()
        Text(mainTitle)
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("background"))
          .padding([.top, .bottom], 16)
        Spacer()
      }
      .background(Color("main"))
    }
  }
}

struct NumberPad_Previews: PreviewProvider {
  static var previews: some View {
    NumberPad(mainTitle: "EXCHANGE", onNumberPressed: { _ in }, onMainPressed: {})
  }
}
