import Foundation
import RxSwift
import zrxkit

class ExchangeViewModel: ObservableObject {
  enum ExchangeInputType {
    case BASE, QUOTE
  }
  
  enum ExchangeListShowType {
    case SEND, RECEIVE, NONE, CONFIRM, PROGRESS, TRANSACTION_SENT, ERROR
  }
  
  let disposeBag = DisposeBag()
  
  let relayer = App.instance.relayerAdapterManager.mainRelayer
  let coinManager = App.instance.coinManager
  
  var blurContent: Bool {
    switch viewState {
    case .CONFIRM, .PROGRESS, .TRANSACTION_SENT, .ERROR:
      return true
    case .NONE, .SEND, .RECEIVE:
      return false
    }
  }
  
  @Published var baseInputText: String? = nil
  @Published var quoteInputText: String? = nil
  @Published var isBaseEditing = false
  @Published var isQuoteEditing = false
  
  @Published var sendCoinsPair: ExchangePairsInfo? = nil
  @Published var receiveCoinsPair: ExchangePairsInfo? = nil
  
  @Published var isMarketOrder: Bool = true
  
  var transactionHash: String = ""
  
  var errorMessage: String?
  
  var exchangeConfirmViewModel: ExchangeConfirmViewModel {
    ExchangeConfirmViewModel(
      info: ExchangeConfirmInfo(
        sendCoin: state.sendCoin?.code ?? "",
        receiveCoin: state.receiveCoin?.code ?? "",
        sendAmount: state.sendAmount,
        receiveAmount: state.receiveAmount,
        showLifeTimeInfo: !isMarketOrder,
        onConfirm: {
          print("CONFIRM")
          self.viewState = .PROGRESS
          if self.isMarketOrder {
            self.marketBuy()
          } else {
            self.postOrder()
          }
        }
      )
    )
  }
  
  var filteredSendCoinsPair: ExchangePairsInfo? {
    guard let pair = sendCoinsPair else { return nil }
    var coins = pair.coins.filter { $0.code != pair.selectedCoin?.code }
    var selectedCoin = pair.selectedCoin!
    selectedCoin.state = .up
    coins.insert(selectedCoin, at: 0)
    return ExchangePairsInfo(coins: coins, selectedCoin: pair.selectedCoin)
  }
  
  var filteredReceiveCoinsPair: ExchangePairsInfo? {
    guard let pair = receiveCoinsPair else { return nil }
    var coins = pair.coins.filter { $0.code != pair.selectedCoin?.code }
    var selectedCoin = pair.selectedCoin!
    selectedCoin.state = .up
    coins.insert(selectedCoin, at: 0)
    return ExchangePairsInfo(coins: coins, selectedCoin: pair.selectedCoin)
  }
  
  var priceInfo: Decimal {
    return Decimal(string: quoteInputText ?? "") ?? 0
  }
  
  var inputType: ExchangeInputType? = nil
  
  var sendCoins: [ExchangeCoinViewItem] = []
  
  var receiveCoins: [ExchangeCoinViewItem] = []
  
  var exchangeableCoins: [Coin] = []
  var marketCodes: [Pair<String, String>] = []
  
  var state: ExchangeViewState = ExchangeViewState(sendAmount: 0, receiveAmount: 0)
  
  let adapterManager = App.instance.adapterManager
  
  @Published var viewState: ExchangeListShowType = .NONE
  
  var estimatedSendAmount: Decimal = 0
  var estimatedReceiveAmount: Decimal = 0
  
  let numberFormatter: NumberFormatter
  
  var orderSide: EOrderSide {
    let market = marketCodes[currentMarketPosition]
    
    if market.first == state.sendCoin?.code {
      return EOrderSide.BUY
    } else {
      return EOrderSide.SELL
    }
  }
  
  var currentMarketPosition: Int {
    let sendCoin = state.sendCoin?.code ?? ""
    let receiveCoin = state.receiveCoin?.code ?? ""
    
    return marketCodes.firstIndex { (pair) -> Bool in
      return (pair.first == sendCoin && pair.second == receiveCoin) ||
        (pair.first == receiveCoin && pair.second == sendCoin)
    } ?? -1
  }
  
  init() {
    
    numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 4
    
    marketCodes = relayer.exchangePairs.map { Pair<String, String>(first: $0.baseCoinCode, second: $0.quoteCoinCode) }
    
    exchangeableCoins = coinManager.coins.filter { coin -> Bool in
      marketCodes.first { pair -> Bool in
        pair.first == coin.code || pair.second == coin.code
      } != nil
    }
    
    refreshPairs(state: nil)
    
    initState(sendItem: sendCoins.first, receiveItem: receiveCoins.first)
    
    refreshPairs(state: state)
    
    adapterManager.adaptersUpdatedSignal.subscribe(onNext: {
      Logger.d("refresh")
      self.refreshPairs(state: self.state)
    }).disposed(by: disposeBag)
  }
  
  func initState(sendItem: ExchangeCoinViewItem?, receiveItem: ExchangeCoinViewItem?) {
    state = ExchangeViewState(sendAmount: 0, sendCoin: sendItem, receiveCoin: receiveItem, receiveAmount: 0)
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
      state.sendAmount = Decimal(string: baseInputText ?? "") ?? 0
      updateReceiveAmount()
    case .QUOTE:
      quoteInputText = inputText
      state.receiveAmount = Decimal(string: quoteInputText ?? "") ?? 0
      if isMarketOrder {
        updateSendAmount()
      }
    }
  }
  
  func refreshPairs(state: ExchangeViewState?, refreshSendCoins: Bool = true) {
    if refreshSendCoins {
      sendCoins = getAvailableSendCoins()
    }
    
    sendCoinsPair = ExchangePairsInfo(coins: sendCoins, selectedCoin: self.state.sendCoin)
    
    if !sendCoins.isEmpty {
      let sendCoin = state?.sendCoin?.code ?? sendCoins.first!.code
      receiveCoins = getAvailableReceiveCoins(baseCoinCode: sendCoin)
      receiveCoinsPair = ExchangePairsInfo(coins: receiveCoins, selectedCoin: receiveCoins.first)
      
      let currentReceiveIndex = receiveCoins.firstIndex { $0.code == state?.receiveCoin?.code }
      if (currentReceiveIndex == nil || self.state.receiveCoin == nil) {
        self.state.receiveCoin = receiveCoins.first
        receiveCoinsPair = ExchangePairsInfo(coins: receiveCoins, selectedCoin: receiveCoins.first)
      }
    }
  }
  
  func getAvailableSendCoins() -> [ExchangeCoinViewItem] {
    exchangeableCoins.map { getExchangeItem(coin: $0) }
  }
  
  func getExchangeItem(coin: Coin) -> ExchangeCoinViewItem {
    let balance = adapterManager.balanceAdapter(for: coin)?.balance ?? 0
    return ExchangeCoinViewItem(code: coin.code, balance: balance, state: .none)
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
    viewState = viewState == .SEND ? .NONE : .SEND
  }
  
  func openReceiveCoinList() {
    viewState = viewState == .RECEIVE ? .NONE : .RECEIVE
  }
  
  func selectSendCoin(coin: ExchangeCoinViewItem) {
    viewState = .NONE
    
    if (coin.code == state.receiveCoin?.code) {
      state.sendCoin = coin
      state.receiveCoin = nil
      refreshPairs(state: state)
    } else if (state.sendCoin?.code != coin.code) {
      state.sendCoin = coin
      refreshPairs(state: state)
      updateReceiveAmount()
    }
  }
  
  func selectReceiveCoin(coin: ExchangeCoinViewItem) {
    viewState = .NONE
    if (state.receiveCoin?.code != coin.code) {
      state.receiveCoin = coin
      receiveCoinsPair?.selectedCoin = coin
      updateReceiveAmount()
    }
  }
  
  func exchangePressed() {
    viewState = .CONFIRM
  }
  
  private func marketBuy() {
    if state.sendAmount > 0 && estimatedReceiveAmount > 0 {
      let fillData = FillOrderData(
        coinPair: marketCodes[currentMarketPosition],
        side: orderSide,
        amount: estimatedReceiveAmount
      )
      print("MARKET BUY")
      
      print(fillData)
      
      relayer.fill(fillData: fillData).observeOn(MainScheduler.instance).subscribe(onNext: { (ethData) in
        self.transactionHash = ethData.hex()
        self.viewState = .TRANSACTION_SENT
      }, onError: { (err) in
        self.viewState = .ERROR
        self.errorMessage = err.localizedDescription
        Logger.e("", error: err)
      }, onCompleted: {
        print("OnComplete")
      }).disposed(by: disposeBag)
    }
    
    print("send amount \(state.sendAmount)")
    print("estimated receive amount \(estimatedReceiveAmount)")
  }
  
  private func postOrder() {
    if state.sendAmount > 0 && priceInfo > 0 {
      let orderData = CreateOrderData(
        coinPair: marketCodes[currentMarketPosition],
        side: orderSide == .BUY ? .SELL : .BUY,
        amount: state.sendAmount,
        price: priceInfo
      )
      
      print("\(marketCodes[currentMarketPosition].first) \(marketCodes[currentMarketPosition].second)")
      
      relayer.createOrder(createData: orderData)
        .observeOn(MainScheduler.instance)
        .subscribe(onError: { (err) in
          self.errorMessage = "Something went wrong"
          self.viewState = .ERROR
          print("Error \(err)")
        }, onCompleted: {
          self.viewState = .ERROR
          self.errorMessage = "Successfully created"
          print("Order posted")
        })
      .disposed(by: disposeBag)
    }
  }
  
  func updateReceiveAmount() {
    if isMarketOrder {
      let currentMarket = currentMarketPosition
      if currentMarket < 0 { return }
      
      let fillResult = relayer.calculateFillAmount(
        coinPair: marketCodes[currentMarket],
        side: orderSide,
        amount: state.sendAmount
      )
      
      print(fillResult)
      
      estimatedReceiveAmount = fillResult.receiveAmount
      
      let roundedReceiveAmount = estimatedReceiveAmount.toDisplayFormat()
      state.receiveAmount = Decimal(string: roundedReceiveAmount) ?? 0
      quoteInputText = roundedReceiveAmount
      
    } else {
      let receiveAmount = state.sendAmount * priceInfo
      print(receiveAmount)
    }
  }
  
  func updateSendAmount() {
    let currentMarket = currentMarketPosition
    if currentMarket < 0 { return }
    
    let fillResult = relayer.calculateSendAmount(
      coinPair: marketCodes[currentMarket],
      side: orderSide,
      amount: state.receiveAmount
    )
    
    estimatedSendAmount = fillResult.sendAmount
    
    let roundedSendAmount = numberFormatter.string(from: NSNumber(value: (estimatedSendAmount as NSDecimalNumber).doubleValue))!
    state.sendAmount = Decimal(string: roundedSendAmount) ?? 0
    baseInputText = roundedSendAmount
    
    estimatedSendAmount = fillResult.receiveAmount != state.receiveAmount ? fillResult.receiveAmount : state.receiveAmount
  }
}
