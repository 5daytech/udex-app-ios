import Foundation
import RxSwift

class SendViewModel: ObservableObject {
  private let disposeBag = DisposeBag()
  private let ratesConverter = App.instance.ratesConverter
  
  let coin: Coin
  @Published var amount: String? = nil
  
  var sendAmount: Decimal = 0
  @Published var sendAmountInFiat: Decimal = 0
  @Published var sendDisabled: Bool = true
  @Published var address: String? = nil
  
  private var savedAddress: String?
  
  let availableBalance: Decimal
  
  private let onConfirm: (SendConfirmConfig) -> Void
  
  
  init(
    coin: Coin,
    onConfirm: @escaping (SendConfirmConfig) -> Void
  ) {
    self.coin = coin
    self.onConfirm = onConfirm
    availableBalance = App.instance.adapterManager.balanceAdapter(for: coin)!.balance
  }
  
  func inputNumber(_ number: String) {
    var inputText = amount
    switch number {
    case "d":
      if inputText != nil {
        if inputText!.count > 0 {
          inputText!.removeLast()
        }
        if inputText!.count == 0 {
          inputText = nil
        }
      }
    default:
      if inputText == nil {
        inputText = ""
      }
      inputText?.append(number)
    }
    amount = inputText
    proccessAmount(amount)
  }
  
  private func proccessAmount(_ amount: String?) {
    sendAmount = Decimal(string: amount ?? "") ?? 0
    sendAmountInFiat = ratesConverter.getCoinsPrice(code: coin.code, amount: sendAmount)
    sendDisabled = sendAmount <= 0 || sendAmount > availableBalance || address == nil
  }
  
  func setAddress(_ address: String?) {
    self.address = address
    self.savedAddress = address
    proccessAmount(amount)
  }
  
  func onSend() {
    let fee: Decimal = App.instance.adapterManager.sendAdapter(for: coin)!.fee(value: sendAmount, address: address, feePriority: .MEDIUM)
    let totalFiat = App.instance.ratesConverter.getCoinsPrice(code: "ETH", amount: fee) + sendAmountInFiat
    self.onConfirm(SendConfirmConfig(
      sendAmount: sendAmount,
      coin: coin,
      sendAmountInFiat: sendAmountInFiat,
      estimatedFee: fee,
      processingTime: App.instance.processingDurationProvider.getEstimatedDuration(type: .SEND),
      totalFiat: totalFiat,
      receiveAddress: address!))
  }
}
