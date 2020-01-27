import SwiftUI

struct ExchangeView: View {
  @ObservedObject var viewModel: ExchangeViewModel
  @State var isPipeShowing = false
  
  var topPadding: CGFloat = 16
  var coinHeight: CGFloat = 95
  
  private func onBaseInputTap() {
    viewModel.setCurrentInputField(inputType: .BASE)
  }
  
  private func onQuoteInputTap() {
    viewModel.setCurrentInputField(inputType: .QUOTE)
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .trailing) {
        VStack {
          // Input fields
          VStack {
            HStack {
              ExchangeInputView(text: self.viewModel.baseInputText, onTap: self.onBaseInputTap, isPipeShowing: self.viewModel.isBaseEditing, receiveAmount: nil)
              Spacer()
              ExchangeCoinView(item: self.viewModel.sendCoinsPair?.selectedCoin)
                .frame(width: (geometry.size.width / 2) - 20, alignment: .leading)
              .onTapGesture {
                self.viewModel.openSendCoinList()
              }
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            
            Rectangle().frame(height: 1).foregroundColor(Color("separatorLine"))
            
            HStack {
              ExchangeInputView(text: self.viewModel.quoteInputText, onTap: self.onQuoteInputTap, isPipeShowing: self.viewModel.isQuoteEditing, receiveAmount: self.viewModel.inputFieldReceiveAmount)
              Spacer()
              ExchangeCoinView(item: self.viewModel.receiveCoinsPair?.selectedCoin)
              .frame(width: (geometry.size.width / 2) - 20, alignment: .leading)
              .onTapGesture {
                self.viewModel.openReceiveCoinList()
              }
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
          }
        .background(Color("secondary_background"))
          .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
          Spacer()
          // Number pad
          NumberPad(mainTitle: self.viewModel.mainButtonTitle, onNumberPressed: { (number) in
            self.viewModel.inputNumber(input: number)
          }) {
            withAnimation {
              self.viewModel.exchangePressed()
            }
          }
        }
        .disabled(self.viewModel.blurContent)
        .blur(radius: self.viewModel.blurContent ? 3 : 0)
        
        if self.viewModel.viewState == .SEND {
          List {
            ForEach(self.viewModel.filteredSendCoinsPair!.coins, id: \.self) { coin in
              ExchangeCoinView(item: coin)
                .listRowBackground(Color("secondary_background"))
              .onTapGesture {
                self.viewModel.selectSendCoin(coin: coin)
              }
            }
          }
          .shadow(radius: 5)
          .frame(width: (geometry.size.width / 2) + 5)
          .padding(EdgeInsets(top: self.topPadding + 62, leading: 0, bottom: 0, trailing: 0))
        } else if self.viewModel.viewState == .RECEIVE {
          List {
            ForEach(self.viewModel.filteredReceiveCoinsPair!.coins, id: \.self) { coin in
              ExchangeCoinView(item: coin)
                .listRowBackground(Color("secondary_background"))
              .onTapGesture {
                self.viewModel.selectReceiveCoin(coin: coin)
              }
            }
          }
          .shadow(radius: 5)
          .frame(width: (geometry.size.width / 2) + 5)
          .padding(EdgeInsets(top: self.topPadding + self.coinHeight + 62, leading: 0, bottom: 0, trailing: 0))
        } else if self.viewModel.viewState == .CONFIRM {
          ExchangeConfirmView(viewModel: self.viewModel.exchangeConfirmViewModel)
            .transition(.move(edge: .bottom))
        } else if self.viewModel.viewState == .PROGRESS {
          ProcessingDialog()
          .transition(.move(edge: .bottom))
        } else if self.viewModel.viewState == .TRANSACTION_SENT {
          TransactionSentDialog(hash: self.viewModel.transactionHash)
          .transition(.move(edge: .bottom))
        } else if self.viewModel.viewState == .ERROR {
          ErrorDialog(message: self.viewModel.errorMessage ?? "") {
            withAnimation {
              self.viewModel.viewState = .NONE
            }
          }
        }
      }
      .background(Color("background"))
      .onTapGesture {
        if self.viewModel.blurContent {
          withAnimation {
            self.viewModel.viewState = .NONE
          }
        }
      }
    }
  }
}
