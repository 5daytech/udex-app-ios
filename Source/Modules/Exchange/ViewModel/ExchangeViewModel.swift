import Foundation
import RxSwift
import zrxkit

class ExchangeViewModel<T: IExchangeViewState>: ObservableObject {
  enum ExchangeInputType {
    case BASE, QUOTE
  }
  
  let disposeBag = DisposeBag()
  
  let relayer = App.instance.relayerAdapterManager.mainRelayer
  let coinManager = App.instance.coinManager
  
  @Published var baseInputText: String? = nil
  @Published var quoteInputText: String? = nil
  @Published var isBaseEditing = false
  @Published var isQuoteEditing = false
  
  @Published var sendCoinsPair: ExchangePairsInfo? = nil
  @Published var receiveCoinsPair: ExchangePairsInfo? = nil
  
  var inputType: ExchangeInputType? = nil
  
  var sendCoins: [ExchangeCoinViewItem] = []
  
  var receiveCoins: [ExchangeCoinViewItem] = []
  
  var exchangeableCoins: [Coin] = []
  var marketCodes: [Pair<String, String>] = []
  
  var state: T? // Should override
  
  let adapterManager = App.instance.adapterManager
  
  init() {
    marketCodes = relayer.exchangePairs.map { Pair<String, String>(first: $0.baseCoinCode, second: $0.quoteCoinCode) }
    
    exchangeableCoins = coinManager.coins.filter { coin -> Bool in
      marketCodes.first { pair -> Bool in
        pair.first == coin.code || pair.second == coin.code
      } != nil
    }
    
    refreshPairs(state: nil)
    
    initState(sendItem: sendCoins.first, receiveItem: receiveCoins.first)
    
    adapterManager.adaptersReadyObservable.subscribe(onNext: {
      Logger.d("refresh")
      self.refreshPairs(state: self.state)
    }).disposed(by: disposeBag)
  }
  
  func initState(sendItem: ExchangeCoinViewItem?, receiveItem: ExchangeCoinViewItem?) {
    //Must override
  }
  
  func setCurrentInputField(inputType: ExchangeInputType) {
    self.inputType = inputType
    switch inputType {
    case .BASE:
      isBaseEditing = true
      isQuoteEditing = false
    case .QUOTE:
      isBaseEditing = false
      isQuoteEditing = true
    }
  }
  
  func inputNumber(input: String) {
    
    guard let inputType = inputType else { return }
    
    var inputText = inputType == .BASE ? baseInputText : quoteInputText
    switch input {
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
      inputText?.append(input)
    }
    
    switch inputType {
    case .BASE:
      baseInputText = inputText
    case .QUOTE:
      quoteInputText = inputText
    }
  }
  
  func refreshPairs(state: T?, refreshSendCoins: Bool = true) {
    if refreshSendCoins {
      sendCoins = getAvailableSendCoins()
      sendCoinsPair = ExchangePairsInfo(coins: sendCoins, selectedCoin: self.state?.sendCoin)
    }
    
    if !sendCoins.isEmpty {
      let sendCoin = state?.sendCoin?.code ?? sendCoins.first!.code
      receiveCoins = getAvailableReceiveCoins(baseCoinCode: sendCoin)
      receiveCoinsPair = ExchangePairsInfo(coins: receiveCoins, selectedCoin: self.state?.receiveCoin)
      
      let currentReceiveIndex = receiveCoins.firstIndex { $0.code == state?.receiveCoin?.code }
      if (currentReceiveIndex == 0 || self.state?.receiveCoin == nil) {
        self.state?.receiveCoin = receiveCoins.first
        receiveCoinsPair = ExchangePairsInfo(coins: receiveCoins, selectedCoin: state?.receiveCoin)
      }
    }
  }
  
  func getAvailableSendCoins() -> [ExchangeCoinViewItem] {
    exchangeableCoins.map { getExchangeItem(coin: $0) }
  }
  
  func getExchangeItem(coin: Coin) -> ExchangeCoinViewItem {
    let balance = adapterManager.balanceAdapter(for: coin)?.balance ?? 0
    return ExchangeCoinViewItem(code: coin.code, balance: balance)
  }
  
  func getAvailableReceiveCoins(baseCoinCode: String) -> [ExchangeCoinViewItem] {
    exchangeableCoins.filter { coin -> Bool in
      marketCodes.first { pair -> Bool in
        let isBuySide = pair.first == baseCoinCode && pair.second == coin.code
        let isSellSide = pair.second == baseCoinCode && pair.first == coin.code
        return isBuySide || isSellSide
      } != nil
    }
    .map { getExchangeItem(coin: $0) }
  }
}
