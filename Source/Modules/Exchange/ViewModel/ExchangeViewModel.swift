import Foundation
import RxSwift
import zrxkit

class ExchangeViewModel<T: IMLInteractor>: ObservableObject {  
  static func instance() -> ExchangeViewModel {
    let interactor: T
    switch T.self {
    case is MarketInteractor.Type:
      interactor = MarketInteractor() as! T
    case is LimitInteractor.Type:
      interactor = LimitInteractor() as! T
    default:
      fatalError()
    }
    return ExchangeViewModel<T>(interactor: interactor)
  }
  
  enum ExchangeInputType {
    case BASE, QUOTE
  }
  
  enum ExchangeListShowType {
    case SEND, RECEIVE, NONE, PROGRESS
    case CONFIRM(ExchangeViewState, Bool, Decimal?, () -> Void)
    case TRANSACTION_SENT(String)
    case ERROR(String)
  }
  
  @Published var viewState: ExchangeListShowType = .NONE
  
  let disposeBag = DisposeBag()
  let coinManager = App.instance.coinManager
  
  var blurContent: Bool {
    switch viewState {
    case .CONFIRM, .PROGRESS, .TRANSACTION_SENT, .ERROR:
      return true
    case .NONE, .SEND, .RECEIVE:
      return false
    }
  }
  
  @Published var sendInputText: String? = nil
  @Published var receiveInputText: String? = nil
  @Published var isBaseEditing = false
  @Published var isQuoteEditing = false
  @Published var sendCoinsPair: ExchangePairsInfo? = nil
  @Published var receiveCoinsPair: ExchangePairsInfo? = nil
  @Published var state: ExchangeViewState?
  
  var mainButtonTitle: String {
    interactor.actionTitle
  }
  
  let interactor: T
  
  var filteredSendCoinsPair: ExchangePairsInfo? {
    guard let pair = sendCoinsPair else { return nil }
    var coins = pair.coins.filter { $0.coin.code != pair.selectedCoin?.coin.code }
    var selectedCoin = pair.selectedCoin!
    selectedCoin.state = .up
    coins.insert(selectedCoin, at: 0)
    return ExchangePairsInfo(coins: coins, selectedCoin: pair.selectedCoin)
  }
  
  var filteredReceiveCoinsPair: ExchangePairsInfo? {
    guard let pair = receiveCoinsPair else { return nil }
    var coins = pair.coins.filter { $0.coin.code != pair.selectedCoin?.coin.code }
    var selectedCoin = pair.selectedCoin!
    selectedCoin.state = .up
    coins.insert(selectedCoin, at: 0)
    return ExchangePairsInfo(coins: coins, selectedCoin: pair.selectedCoin)
  }
  
  var priceInfo: Decimal {
    return Decimal(string: receiveInputText ?? "") ?? 0
  }
  
  var inputType: ExchangeInputType? = nil
  
  var sendCoins: [ExchangeCoinViewItem] = []
  var receiveCoins: [ExchangeCoinViewItem] = []
  
  var exchangeableCoins: [Coin] = []
  var marketCodes: [Pair<String, String>] = []
  
  let adapterManager = App.instance.adapterManager
  
  var estimatedSendAmount: Decimal = 0
  var estimatedReceiveAmount: Decimal = 0
  
  var orderSide: EOrderSide {
    interactor.orderSide
  }
  
  init(interactor: T) {
    self.interactor = interactor
    
    interactor.stateObservable.subscribe(onNext: { (state) in
      self.state = state
    }).disposed(by: disposeBag)
    
    interactor.sendAmountObservable.subscribe(onNext: { amount in
      self.sendInputText = amount
    }).disposed(by: disposeBag)
    
    interactor.receiveAmountObservable.subscribe(onNext: { amount in
      self.receiveInputText = amount
    }).disposed(by: disposeBag)
    
    interactor.actionObservable.subscribe(onNext: { (ethData) in
      if ethData != nil {
        self.viewState = .TRANSACTION_SENT(ethData!.hex())
      } else {
        self.viewState = .ERROR("Successfully created")
      }
    }, onError: { (err) in
      self.viewState = .ERROR(err.localizedDescription)
    }).disposed(by: disposeBag)
    
    interactor.sendCoinsObservable.subscribe(onNext: { (coins) in
      self.sendCoinsPair = coins
    }).disposed(by: disposeBag)
    
    interactor.receiveCoinsObservable.subscribe(onNext: { (coins) in
      self.receiveCoinsPair = coins
    }).disposed(by: disposeBag)
    
    exchangeableCoins = coinManager.coins.filter { coin -> Bool in
      marketCodes.first { pair -> Bool in
        pair.first == coin.code || pair.second == coin.code
      } != nil
    }
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
    
    var inputText = inputType == .BASE ? sendInputText : receiveInputText
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
      sendInputText = inputText
      interactor.setSendAmount(sendInputText)
    case .QUOTE:
      receiveInputText = inputText
      interactor.setReceiveAmount(receiveInputText)
    }
  }
  
  func openSendCoinList() {
    switch viewState {
    case .SEND:
      viewState = .NONE
    default:
      viewState = .SEND
    }
  }
  
  func openReceiveCoinList() {
    switch viewState {
    case .RECEIVE:
      viewState = .NONE
    default:
      viewState = .RECEIVE
    }
  }
  
  func selectSendCoin(coin: ExchangeCoinViewItem) {
    viewState = .NONE
    interactor.selectSendCoin(coin)
  }
  
  func selectReceiveCoin(coin: ExchangeCoinViewItem) {
    viewState = .NONE
    interactor.selectReceiveCoin(coin)
  }
  
  func exchangePressed() {
    viewState = .CONFIRM(interactor.state, interactor.isMarketOrder, interactor.calcFee(), {
      self.viewState = .PROGRESS
      self.interactor.mainAction()
    })
  }
}
