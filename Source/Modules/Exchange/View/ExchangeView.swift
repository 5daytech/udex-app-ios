import SwiftUI

struct ExchangeView: View {
  
  @ObservedObject var viewModel: ExchangeViewModel
  
  @State var testText = ""
  @State var isPipeShowing = false
  @State var dim = false
  
  var coinViewSpacer: CGFloat = 60
  
  private func onBaseInputTap() {
    viewModel.setCurrentInputField(inputType: .BASE)
  }
  
  private func onQuoteInputTap() {
    viewModel.setCurrentInputField(inputType: .QUOTE)
  }
  
  var body: some View {
    VStack {
      // Input fields
      VStack {
        HStack {
          ExchangeInputView(text: viewModel.baseInputText, onTap: onBaseInputTap, isPipeShowing: viewModel.isBaseEditing)
          Spacer()
          ExchangeCoinView(item: viewModel.item.base)
          Spacer()
          .frame(minWidth: coinViewSpacer, maxWidth: coinViewSpacer)
        }
        
        HStack {
          ExchangeInputView(text: viewModel.quoteInputText, onTap: onQuoteInputTap, isPipeShowing: viewModel.isQuoteEditing)
          Spacer()
          ExchangeCoinView(item: viewModel.item.quote)
          Spacer()
          .frame(minWidth: coinViewSpacer, maxWidth: coinViewSpacer)
        }
      }
      .padding(20)
      Spacer()
      // Number pad
      VStack {
        VStack(alignment: .center, spacing: 40) {
          HStack {
            Button(action: {
              self.viewModel.inputNumber(input: "1")
            }) {
              Text("1")
            }
            Spacer()
            Button(action: {
              self.viewModel.inputNumber(input: "2")
            }) {
              Text("2")
            }
            Spacer()
            Button(action: {
              self.viewModel.inputNumber(input: "3")
            }) {
              Text("3")
            }
          }
          HStack {
            Button(action: {
              self.viewModel.inputNumber(input: "4")
            }) {
              Text("4")
            }
            Spacer()
            Button(action: {
              self.viewModel.inputNumber(input: "5")
            }) {
              Text("5")
            }
            Spacer()
            Button(action: {
              self.viewModel.inputNumber(input: "6")
            }) {
              Text("6")
            }
          }
          HStack {
            Button(action: {
              self.viewModel.inputNumber(input: "7")
            }) {
              Text("7")
            }
            Spacer()
            Button(action: {
              self.viewModel.inputNumber(input: "8")
            }) {
              Text("8")
            }
            Spacer()
            Button(action: {
              self.viewModel.inputNumber(input: "9")
            }) {
              Text("9")
            }
          }
          HStack {
            Button(action: {
              self.viewModel.inputNumber(input: ".")
            }) {
              Text(".")
            }
            Spacer()
            Button(action: {
              self.viewModel.inputNumber(input: "0")
            }) {
              Text("0")
            }
            Spacer()
            Button(action: {
              self.viewModel.inputNumber(input: "d")
            }) {
              Text("d")
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
          // onExchange pressed
        }) {
          Text("EXCHANGE")
        }
        .frame(height: CGFloat(60.0))
      }
    }
  }
}

struct ExchangeView_Previews: PreviewProvider {
  static var previews: some View {
    ExchangeView(viewModel: ExchangeViewModel())
  }
}
