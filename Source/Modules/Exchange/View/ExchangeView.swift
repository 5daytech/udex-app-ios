import SwiftUI

struct ExchangeView<T: IMLInteractor>: View {
  static func makeView() -> ExchangeView {
    ExchangeView(viewModel: ExchangeViewModel<T>.instance())
  }
  
  @ObservedObject var viewModel: ExchangeViewModel<T>
  @State var isPipeShowing = false
  
  var topPadding: CGFloat = 16
  var coinHeight: CGFloat = 95
  
  private func onBaseInputTap() {
    viewModel.setCurrentInputField(inputType: .BASE)
  }
  
  private func onQuoteInputTap() {
    viewModel.setCurrentInputField(inputType: .QUOTE)
  }
  
  private func topView(_ geometry: GeometryProxy) -> AnyView? {
    switch viewModel.viewState {
    case .SEND:
      return AnyView(
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
        .padding(EdgeInsets(top: self.topPadding, leading: 0, bottom: 0, trailing: 0))
      )
    case .RECEIVE:
      return AnyView(
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
        .padding(EdgeInsets(top: self.topPadding + self.coinHeight, leading: 0, bottom: 0, trailing: 0))
      )
    case .CONFIRM(let state, let isMarketOrder, let fee, let onConfirm):
      return AnyView(
        ExchangeConfirmView(
          viewModel: ExchangeConfirmViewModel(
            info: ExchangeConfirmInfo(
              sendCoin: state.sendCoin?.coin.code ?? "",
              receiveCoin: state.receiveCoin?.coin.code ?? "",
              sendAmount: state.sendAmount,
              receiveAmount: state.receiveAmount,
              fee: fee,
              showLifeTimeInfo: !isMarketOrder,
              onConfirm: onConfirm
            )
          )
        )
        .transition(.move(edge: .bottom))
      )
    case .PROGRESS:
      return AnyView(
        ProcessingDialog()
        .transition(.move(edge: .bottom))
      )
    case .TRANSACTION_SENT(let hash):
      return AnyView(
        TransactionSentDialog(hash: hash)
        .transition(.move(edge: .bottom))
      )
    case .ERROR(let message):
      return AnyView(
        ErrorDialog(message: message) {
          withAnimation {
            self.viewModel.viewState = .NONE
          }
        }
      )
    case .NONE:
      return nil
    }
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .trailing) {
        VStack {
          // Input fields
          VStack {
            HStack {
              ExchangeInputView(
                text: self.viewModel.sendInputText,
                onTap: self.onBaseInputTap,
                isPipeShowing: self.viewModel.isBaseEditing,
                receiveAmount: nil,
                errorMessage: self.viewModel.state?.errorMessageSend,
                fiatAmount: nil,
                availableAmount: self.viewModel.state?.sendAvailableAmount?.toDisplayFormat()
              )
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
              ExchangeInputView(
                text: self.viewModel.receiveInputText,
                onTap: self.onQuoteInputTap,
                isPipeShowing: self.viewModel.isQuoteEditing,
                receiveAmount: self.viewModel.state?.receiveTotal,
                errorMessage: nil,
                fiatAmount: nil,
                availableAmount: self.viewModel.state?.receiveAvailableAmount?.toDisplayFormat()
              )
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
          ExchangeNumberPad(
            mainTitle: self.viewModel.mainButtonTitle,
            onNumberPressed: { (number) in
              self.viewModel.inputNumber(input: number)
            }
          ) {
            withAnimation {
              self.viewModel.exchangePressed()
            }
          }
        }
        .disabled(self.viewModel.blurContent)
        .blur(radius: self.viewModel.blurContent ? 3 : 0)
        
        self.topView(geometry)
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
