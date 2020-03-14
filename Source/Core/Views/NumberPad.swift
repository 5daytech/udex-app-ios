import SwiftUI

struct NumberPad: View {
  var onNumberPressed: (String) -> Void
  var body: some View {
    HStack {
      VStack(alignment: .center, spacing: 40) {
        Button(action: {
          self.onNumberPressed("1")
        }) {
          Text("1")
            .font(.custom(Constants.Fonts.regular, size: 20))
            .foregroundColor(Color("T1"))
        }
        Button(action: {
          self.onNumberPressed("4")
        }) {
          Text("4")
            .font(.custom(Constants.Fonts.regular, size: 20))
            .foregroundColor(Color("T1"))
        }
        Button(action: {
          self.onNumberPressed("7")
        }) {
          Text("7")
            .font(.custom(Constants.Fonts.regular, size: 20))
            .foregroundColor(Color("T1"))
        }
        Button(action: {
          self.onNumberPressed(".")
        }) {
          Text(".")
            .font(.custom(Constants.Fonts.regular, size: 20))
            .foregroundColor(Color("T1"))
        }
      }
      Spacer()
      VStack(alignment: .center, spacing: 40) {
        Button(action: {
          self.onNumberPressed("2")
        }) {
          Text("2")
            .font(.custom(Constants.Fonts.regular, size: 20))
            .foregroundColor(Color("T1"))
        }
        Button(action: {
          self.onNumberPressed("5")
        }) {
          Text("5")
            .font(.custom(Constants.Fonts.regular, size: 20))
            .foregroundColor(Color("T1"))
        }
        Button(action: {
          self.onNumberPressed("8")
        }) {
          Text("8")
            .font(.custom(Constants.Fonts.regular, size: 20))
            .foregroundColor(Color("T1"))
        }
        Button(action: {
          self.onNumberPressed("0")
        }) {
          Text("0")
            .font(.custom(Constants.Fonts.regular, size: 20))
            .foregroundColor(Color("T1"))
        }
      }
      Spacer()
      VStack(alignment: .center, spacing: 40) {
        Button(action: {
          self.onNumberPressed("3")
        }) {
          Text("3")
            .font(.custom(Constants.Fonts.regular, size: 20))
            .foregroundColor(Color("T1"))
        }
        Button(action: {
          self.onNumberPressed("6")
        }) {
          Text("6")
            .font(.custom(Constants.Fonts.regular, size: 20))
            .foregroundColor(Color("T1"))
        }
        Button(action: {
          self.onNumberPressed("9")
        }) {
          Text("9")
            .font(.custom(Constants.Fonts.regular, size: 20))
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
  }
}

struct NumberPad_Previews: PreviewProvider {
  static var previews: some View {
    NumberPad { _ in }
  }
}
