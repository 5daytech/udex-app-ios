import Foundation
import BigInt
import RxSwift

class ConvertViewModel: ObservableObject {
  enum ConvertViewState {
    case none
    case confirm
    case processing
    case transactionSent(String)
    case error(String)
  }
  
  private let disposeBag = DisposeBag()
  private let adapterManager = App.instance.adapterManager
  private let coinManager = App.instance.coinManager
  private let ratesConverter = App.instance.ratesConverter
  private let wethWrapper = App.instance.zrxKitManager.zrxKit().getWethWrapperInstance()
  
  @Published var amount: String? = nil
  @Published var wrapDisabled: Bool = true
  @Published var availableBalance: Decimal = 0.0
  @Published var availableBalanceInFiat: Decimal = 0.0
  @Published var sendAmountInFiat: Decimal = 0.0
  @Published var estimatedFee: Decimal = 0.0
  @Published var title: String
  @Published var coinCode: String
  
  private var sendAmount: Decimal = 0.0
  let config: ConvertConfig
  let onDone: () -> Void
  let onConfirm: (ConvertConfirmConfig) -> Void
  let onProcessing: () -> Void
  let onTransaction: (String) -> Void
  let onError: (String) -> Void
  @Published var viewState: ConvertViewState
  
  init(
    config: ConvertConfig,
    onDone: @escaping () -> Void,
    onConfirm: @escaping (ConvertConfirmConfig) -> Void,
    onProcessing: @escaping () -> Void,
    onTransaction: @escaping (String) -> Void,
    onError: @escaping (String) -> Void
  ) {
    self.onDone = onDone
    self.onConfirm = onConfirm
    self.onProcessing = onProcessing
    self.onTransaction = onTransaction
    self.onError = onError
    self.config = config
    self.coinCode = config.coinCode
    self.title = config.type.title
    self.viewState = .none
    let fromCoin = coinManager.getCoin(code: config.coinCode)
    let toCoin = coinManager.getCoin(code: config.type == .WRAP ? "WETH" : "ETH")
    let fromAdapter = adapterManager.balanceAdapter(for: fromCoin)
    availableBalance = fromAdapter!.balance
    availableBalanceInFiat = ratesConverter.getCoinsPrice(code: fromCoin.code, amount: availableBalance)
    estimatedFee = wethWrapper.depositEstimatedPrice.toNormalDecimal(decimal: 18)
  }
  
  func setAmount(_ number: String) {
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
    sendAmountInFiat = ratesConverter.getCoinsPrice(code: config.coinCode, amount: sendAmount)
    wrapDisabled = sendAmount <= 0 || sendAmount > availableBalance
  }
  
  func convert() {
    viewState = .confirm
    self.onConfirm(ConvertConfirmConfig(
      value: sendAmount,
      estimatedFee: 0.0008,
      processingTime: 20,
      type: config.type))
  }
}
