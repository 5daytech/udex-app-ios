import Foundation
import RxSwift
import Web3
import zrxkit

class BaseInteractor {
  internal let disposeBag = DisposeBag()
  internal var title: String { "" }
  internal var isMarket: Bool { true }
  internal var marketCodes: [Pair<String, String>] = []
  internal let relayer = App.instance.relayerAdapterManager.mainRelayer
  internal let actionSubject = PublishSubject<EthereumData?>()
  internal let sendAmountSubject = PublishSubject<String>()
  internal let receiveAmountSubject = PublishSubject<String>()
  internal let adapterManager = App.instance.adapterManager
  
  private let stateSubject = PublishSubject<ExchangeViewState>()
  private let coinManager = App.instance.coinManager
  private var sendCoins: [ExchangeCoinViewItem] = []
  private var receiveCoins: [ExchangeCoinViewItem] = []
  private var exchangeableCoins: [Coin] = []
  private let sendCoinsSubject = BehaviorSubject<ExchangePairsInfo?>(value: nil)
  private let receiveCoinsSubject = BehaviorSubject<ExchangePairsInfo?>(value: nil)
  
  private var sendCoinsPair: ExchangePairsInfo? = nil {
    didSet {
      sendCoinsSubject.onNext(sendCoinsPair)
    }
  }
  private var receiveCoinsPair: ExchangePairsInfo? = nil {
    didSet {
      receiveCoinsSubject.onNext(receiveCoinsPair)
    }
  }
  
  internal var state = ExchangeViewState() {
    didSet {
      stateSubject.onNext(state)
    }
  }
  
  internal var currentMarketPosition: Int {
    let sendCoin = state.sendCoin?.coin.code ?? ""
    let receiveCoin = state.receiveCoin?.coin.code ?? ""
    
    return marketCodes.firstIndex { (pair) -> Bool in
      return (pair.first == sendCoin && pair.second == receiveCoin) ||
        (pair.first == receiveCoin && pair.second == sendCoin)
    } ?? -1
  }
  
  init() {
    marketCodes = relayer?.exchangePairs.map { Pair<String, String>(first: $0.baseCoinCode, second: $0.quoteCoinCode) } ?? []
    
    exchangeableCoins = coinManager.coins.filter { coin -> Bool in
      marketCodes.first { pair -> Bool in
        pair.first == coin.code || pair.second == coin.code
      } != nil
    }
    
    refreshPairs(state: nil, refreshSendCoins: true)
    
    state = ExchangeViewState(sendCoin: sendCoins.first, receiveCoin: receiveCoins.first)
    
    refreshPairs(state: state, refreshSendCoins: true)
    
    adapterManager.adaptersUpdatedSignal.subscribe(onNext: {
      self.refreshPairs(state: self.state)
    }).disposed(by: disposeBag)
  }
  
  // MARK: Internal
  
  internal func action() { fatalError("Must implement in child") }
  
  internal func updateReceiveAmount() { fatalError("Must implement in child") }
  
  internal func updateSendAmount() { fatalError("Must implement in child") }
  
  // MARK: Private
  
  private func updateSendHint() {
    let balanceAdapter = adapterManager.balanceAdapter(for: state.sendCoin!.coin)!
    let errors = balanceAdapter.validate(amount: state.sendAmount, feePriority: .HIGHEST)
    if !errors.isEmpty {
      errors.forEach { (sendStateError) in
        switch sendStateError {
        case .insufficientAmount:
          state.errorMessageSend = "Insfficient balance!"
        case .insufficientFeeBalance:
          state.errorMessageSend = "Insfficient ETH balance for fee!"
        }
      }
    } else {
      state.errorMessageSend = nil
    }
  }
  
  private func refreshPairs(state: ExchangeViewState?, refreshSendCoins: Bool = true) {
    if refreshSendCoins {
      sendCoins = getAvailableSendCoins()
    }
    
    sendCoinsPair = ExchangePairsInfo(coins: sendCoins, selectedCoin: self.state.sendCoin)
    
    if !sendCoins.isEmpty {
      let sendCoin = state?.sendCoin?.coin.code ?? sendCoins.first!.coin.code
      receiveCoins = getAvailableReceiveCoins(baseCoinCode: sendCoin)
      receiveCoinsPair = ExchangePairsInfo(coins: receiveCoins, selectedCoin: receiveCoins.first)
      
      let currentReceiveIndex = receiveCoins.firstIndex { $0.coin.code == state?.receiveCoin?.coin.code }
      if (currentReceiveIndex == nil || self.state.receiveCoin == nil) {
        self.state.receiveCoin = receiveCoins.first
        receiveCoinsPair = ExchangePairsInfo(coins: receiveCoins, selectedCoin: receiveCoins.first)
      }
    }
  }
  
  private func getAvailableSendCoins() -> [ExchangeCoinViewItem] {
    exchangeableCoins.map { getExchangeItem(coin: $0) }
  }
  
  func getExchangeItem(coin: Coin) -> ExchangeCoinViewItem {
    let balance = adapterManager.balanceAdapter(for: coin)?.balance ?? 0
    return ExchangeCoinViewItem(coin: coin, balance: balance, state: .none)
  }
  
  private func getAvailableReceiveCoins(baseCoinCode: String) -> [ExchangeCoinViewItem] {
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

// MARK: IMLInteractor

extension BaseInteractor: IMLInteractor {
  var actionTitle: String { title }
  
  var actionObservable: Observable<EthereumData?> { actionSubject.asObservable() }
  
  var stateObservable: Observable<ExchangeViewState> { stateSubject.asObservable() }
  
  var sendAmountObservable: Observable<String> { sendAmountSubject.asObservable() }
  
  var receiveAmountObservable: Observable<String> { receiveAmountSubject.asObservable() }
  
  var sendCoinsObservable: BehaviorSubject<ExchangePairsInfo?> { sendCoinsSubject }
  
  var receiveCoinsObservable: BehaviorSubject<ExchangePairsInfo?> { receiveCoinsSubject }
  
  var orderSide: EOrderSide {
    marketCodes[currentMarketPosition].first == state.sendCoin?.coin.code ? .BUY : .SELL
  }
  
  var isMarketOrder: Bool { isMarket }
  
  func mainAction() {
    action()
  }
  
  func setSendAmount(_ amount: String?) {
    state.sendAmount = Decimal(string: amount ?? "") ?? 0
    updateReceiveAmount()
    updateSendHint()
  }
  
  func setReceiveAmount(_ amount: String?) {
    state.receiveAmount = Decimal(string: amount ?? "") ?? 0
    updateSendAmount()
  }
  
  func selectSendCoin(_ coin: ExchangeCoinViewItem) {
    if (coin.coin.code == state.receiveCoin?.coin.code) {
      state.sendCoin = coin
      state.receiveCoin = nil
    } else if (state.sendCoin?.coin.code != coin.coin.code) {
      state.sendCoin = coin
    }
    refreshPairs(state: state)
    updateReceiveAmount()
  }
  
  func selectReceiveCoin(_ coin: ExchangeCoinViewItem) {
    if (state.receiveCoin?.coin.code != coin.coin.code) {
      state.receiveCoin = coin
      receiveCoinsPair?.selectedCoin = coin
      updateReceiveAmount()
    }
  }
}
