import SwiftUI

struct ExchangeView: View {
  @ObservedObject var viewModel: ExchangeViewModel
  @State var isPipeShowing = false
  
  var coinViewSpacer: CGFloat = 60
  
  private func onBaseInputTap() {
    viewModel.setCurrentInputField(inputType: .BASE)
  }
  
  private func onQuoteInputTap() {
    viewModel.setCurrentInputField(inputType: .QUOTE)
  }
  
  var body: some View {
    ZStack(alignment: Alignment.trailing) {
      VStack {
        // Market/Limit buttons
        HStack {
          Spacer()
          Button(action: {
            self.viewModel.isMarketOrder = true
          }) {
            Text("MARKET")
            .font(.system(size: 20, weight: .bold))
          }
          .foregroundColor(viewModel.isMarketOrder ? Color("main") : .gray)
          
          Button(action: {
            self.viewModel.isMarketOrder = false
          }) {
            Text("LIMIT")
            .font(.system(size: 20, weight: .bold))
          }
          .foregroundColor(viewModel.isMarketOrder ? .gray : Color("main"))
          Spacer()
        }
        .padding(.top, 16)
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
        VStack(spacing: 30) {
          HStack {
            VStack(alignment: .center, spacing: 40) {
              Button(action: {
                self.viewModel.inputNumber(input: "1")
              }) {
                Text("1")
                .font(.system(size: 25))
                .foregroundColor(Color("T1"))
              }
              Button(action: {
                self.viewModel.inputNumber(input: "4")
              }) {
                Text("4")
                .font(.system(size: 25))
                .foregroundColor(Color("T1"))
              }
              Button(action: {
                self.viewModel.inputNumber(input: "7")
              }) {
                Text("7")
                .font(.system(size: 25))
                .foregroundColor(Color("T1"))
              }
              Button(action: {
                self.viewModel.inputNumber(input: ".")
              }) {
                Text(".")
                .font(.system(size: 25))
                .foregroundColor(Color("T1"))
              }
            }
            Spacer()
            VStack(alignment: .center, spacing: 40) {
              Button(action: {
                self.viewModel.inputNumber(input: "2")
              }) {
                Text("2")
                .font(.system(size: 25))
                .foregroundColor(Color("T1"))
              }
              Button(action: {
                self.viewModel.inputNumber(input: "5")
              }) {
                Text("5")
                .font(.system(size: 25))
                .foregroundColor(Color("T1"))
              }
              Button(action: {
                self.viewModel.inputNumber(input: "8")
              }) {
                Text("8")
                .font(.system(size: 25))
                .foregroundColor(Color("T1"))
              }
              Button(action: {
                self.viewModel.inputNumber(input: "0")
              }) {
                Text("0")
                  .font(.system(size: 25))
                  .foregroundColor(Color("T1"))
              }
            }
            Spacer()
            VStack(alignment: .center, spacing: 40) {
              Button(action: {
                self.viewModel.inputNumber(input: "3")
              }) {
                Text("3")
                .font(.system(size: 25))
                .foregroundColor(Color("T1"))
              }
              Button(action: {
                self.viewModel.inputNumber(input: "6")
              }) {
                Text("6")
                .font(.system(size: 25))
                .foregroundColor(Color("T1"))
              }
              Button(action: {
                self.viewModel.inputNumber(input: "9")
              }) {
                Text("9")
                .font(.system(size: 25))
                .foregroundColor(Color("T1"))
              }
              Button(action: {
                self.viewModel.inputNumber(input: "d")
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
            // onExchange pressed
            withAnimation {
              self.viewModel.exchangePressed()
            }
          }) {
            Spacer()
            Text("EXCHANGE")
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(Color("background"))
              .padding([.top, .bottom], 16)
            Spacer()
          }
          .background(Color("main"))
        }
      }
      .disabled(viewModel.blurContent)
      .blur(radius: viewModel.blurContent ? 3 : 0)
      .onTapGesture {
        if self.viewModel.blurContent {
          withAnimation {
            self.viewModel.viewState = .NONE
          }
        }
      }
      
      
      
      if viewModel.viewState == .SEND {
        List(viewModel.filteredSendCoinsPair!.coins) { coin in
          ExchangeCoinView(item: coin)
          .onTapGesture {
            self.viewModel.selectSendCoin(coin: coin)
          }
          
        }
        .shadow(radius: 5)
        .frame(width: 160)
        .padding(EdgeInsets(top: 140, leading: 0, bottom: 0, trailing: 20))
      } else if viewModel.viewState == .RECEIVE {
        List(viewModel.filteredReceiveCoinsPair!.coins) { coin in
          ExchangeCoinView(item: coin)
          .onTapGesture {
            self.viewModel.selectReceiveCoin(coin: coin)
          }
        }
        .shadow(radius: 5)
        .frame(width: 160)
        .padding(EdgeInsets(top: 210, leading: 0, bottom: 0, trailing: 20))
      } else if viewModel.viewState == .CONFIRM {
        ExchangeConfirmView(viewModel: viewModel.exchangeConfirmViewModel)
          .transition(.move(edge: .bottom))
      } else if viewModel.viewState == .PROGRESS {
        ProcessingDialog()
        .transition(.move(edge: .bottom))
      } else if viewModel.viewState == .TRANSACTION_SENT {
        TransactionSentDialog(hash: viewModel.transactionHash)
        .transition(.move(edge: .bottom))
      } else if viewModel.viewState == .ERROR {
        ErrorDialog(message: "") {
          withAnimation {
            self.viewModel.viewState = .NONE
          }
        }
      }
    }
  }
}
