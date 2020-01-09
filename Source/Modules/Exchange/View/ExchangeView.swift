import SwiftUI

struct ExchangeView: View {
  @ObservedObject var viewModel: LimitExchangeViewModel
  @State var isPipeShowing = false
  
  var coinViewSpacer: CGFloat = 60
  
  private func onBaseInputTap() {
    viewModel.setCurrentInputField(inputType: .BASE)
  }
  
  private func onQuoteInputTap() {
    viewModel.setCurrentInputField(inputType: .QUOTE)
  }
  
  var body: some View {
    ZStack(alignment: .trailing) {
      VStack {
        // Market/Limit buttons
        HStack {
          Spacer()
          Button(action: {
            // change to market
          }) {
            Text("Market")
          }
          
          Button(action: {
            // change to market
          }) {
            Text("Limit")
          }
          Spacer()
        }
        // Input fields
        VStack {
          HStack {
            ExchangeInputView(text: viewModel.baseInputText, onTap: onBaseInputTap, isPipeShowing: viewModel.isBaseEditing)
            Spacer()
            ExchangeCoinView(item: viewModel.filteredSendCoinsPair?.selectedCoin)
            .onTapGesture {
              self.viewModel.openSendCoinList()
            }
            Spacer()
            .frame(minWidth: coinViewSpacer, maxWidth: coinViewSpacer)
          }
          
          HStack {
            ExchangeInputView(text: viewModel.quoteInputText, onTap: onQuoteInputTap, isPipeShowing: viewModel.isQuoteEditing)
            Spacer()
            ExchangeCoinView(item: viewModel.filteredReceiveCoinsPair?.selectedCoin)
            .onTapGesture {
              self.viewModel.openReceiveCoinList()
            }
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
            self.viewModel.placeOrder()
          }) {
            Text("EXCHANGE")
          }
          .frame(height: CGFloat(60.0))
        }
      }
      
      if viewModel.listState == .SEND {
        List(viewModel.filteredSendCoinsPair!.coins) { coin in
          ExchangeCoinView(item: coin)
          .onTapGesture {
            self.viewModel.selectSendCoin(coin: coin)
          }
          
        }
        .frame(width: 185)
        .padding(.top, 90)
      } else if viewModel.listState == .RECEIVE {
        List(viewModel.filteredReceiveCoinsPair!.coins) { coin in
          ExchangeCoinView(item: coin)
          .onTapGesture {
            self.viewModel.selectReceiveCoin(coin: coin)
          }
        }
        .frame(width: 185)
        .padding(.top, 170)
      }
    }
  }
}
