import Foundation
import RxSwift
import zrxkit

class ExchangeViewModel<T: IExchangeViewState>: ObservableObject {
  enum ExchangeInputType {
    case BASE, QUOTE
  }
  
  enum ExchangeListShowType {
    case SEND, RECEIVE, NONE
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
  
  var filteredSendCoinsPair: ExchangePairsInfo? {
    guard let pair = sendCoinsPair else { return nil }
    let coins = pair.coins.filter { $0.code != pair.selectedCoin?.code }
    return ExchangePairsInfo(coins: coins, selectedCoin: pair.selectedCoin)
  }
  
  var filteredReceiveCoinsPair: ExchangePairsInfo? {
    guard let pair = receiveCoinsPair else { return nil }
    let coins = pair.coins.filter { $0.code != pair.selectedCoin?.code }
    return ExchangePairsInfo(coins: coins, selectedCoin: pair.selectedCoin)
  }
  
  var inputType: ExchangeInputType? = nil
  
  var sendCoins: [ExchangeCoinViewItem] = []
  
  var receiveCoins: [ExchangeCoinViewItem] = []
  
  var exchangeableCoins: [Coin] = []
  var marketCodes: [Pair<String, String>] = []
  
  var state: T? // Should override
  
  let adapterManager = App.instance.adapterManager
  
  @Published var listState: ExchangeListShowType = .NONE
  
  var orderSide: EOrderSide {
    let market = marketCodes[currentMarketPosition]
    
    if market.first == state?.sendCoin?.code {
      return EOrderSide.BUY
    } else {
      return EOrderSide.SELL
    }
  }
  
  var currentMarketPosition: Int {
    let sendCoin = state?.sendCoin?.code ?? ""
    let receiveCoin = state?.receiveCoin?.code ?? ""
    
    print("etalon pair - \(sendCoin) : \(receiveCoin)")
    
    return marketCodes.firstIndex { (pair) -> Bool in
      print("\(pair.first) : \(pair.second)")
      return (pair.first == sendCoin && pair.second == receiveCoin) ||
        (pair.first == receiveCoin && pair.second == sendCoin)
    } ?? -1
  }
  
  init() {
    marketCodes = relayer.exchangePairs.map { Pair<String, String>(first: $0.baseCoinCode, second: $0.quoteCoinCode) }
    
    exchangeableCoins = coinManager.coins.filter { coin -> Bool in
      marketCodes.first { pair -> Bool in
        pair.first == coin.code || pair.second == coin.code
      } != nil
    }
    
    refreshPairs(state: nil)
    
    initState(sendItem: sendCoins.first, receiveItem: receiveCoins.first)
    
    refreshPairs(state: state)
    
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
      state?.sendAmount = Decimal(string: baseInputText ?? "") ?? 0
    case .QUOTE:
      quoteInputText = inputText
    }
    updateReceiveAmount()
  }
  
  func refreshPairs(state: T?, refreshSendCoins: Bool = true) {
    if refreshSendCoins {
      sendCoins = getAvailableSendCoins()
    }
    
    sendCoinsPair = ExchangePairsInfo(coins: sendCoins, selectedCoin: self.state?.sendCoin)
    
    if !sendCoins.isEmpty {
      let sendCoin = state?.sendCoin?.code ?? sendCoins.first!.code
      receiveCoins = getAvailableReceiveCoins(baseCoinCode: sendCoin)
      receiveCoinsPair = ExchangePairsInfo(coins: receiveCoins, selectedCoin: receiveCoins.first)
      
      let currentReceiveIndex = receiveCoins.firstIndex { $0.code == state?.receiveCoin?.code }
      if (currentReceiveIndex == nil || self.state?.receiveCoin == nil) {
        self.state?.receiveCoin = receiveCoins.first
        receiveCoinsPair = ExchangePairsInfo(coins: receiveCoins, selectedCoin: receiveCoins.first)
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
  
  func openSendCoinList() {
    listState = listState == .SEND ? .NONE : .SEND
  }
  
  func openReceiveCoinList() {
    listState = listState == .RECEIVE ? .NONE : .RECEIVE
  }
  
  func selectSendCoin(coin: ExchangeCoinViewItem) {
    listState = .NONE
    
    if (coin.code == state?.receiveCoin?.code) {
      state?.sendCoin = coin
      state?.receiveCoin = nil
      refreshPairs(state: state, refreshSendCoins: false)
    } else if (state?.sendCoin?.code != coin.code) {
      state?.sendCoin = coin
      refreshPairs(state: state, refreshSendCoins: false)
      updateReceiveAmount()
    }
  }
  
  func selectReceiveCoin(coin: ExchangeCoinViewItem) {
    listState = .NONE
    if (state?.receiveCoin?.code != coin.code) {
      state?.receiveCoin = coin
      receiveCoinsPair?.selectedCoin = coin
      updateReceiveAmount()
    }
  }
  
  func updateReceiveAmount() {
    
  }
}
