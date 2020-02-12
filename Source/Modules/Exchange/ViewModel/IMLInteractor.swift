import Foundation
import RxSwift
import Web3

protocol IMLInteractor {
  var actionTitle: String { get }
  var actionObservable: Observable<EthereumData?> { get }
  var stateObservable: Observable<ExchangeViewState> { get }
  var sendAmountObservable: Observable<String> { get }
  var receiveAmountObservable: Observable<String> { get }
  var sendCoinsObservable: BehaviorSubject<ExchangePairsInfo?> { get }
  var receiveCoinsObservable: BehaviorSubject<ExchangePairsInfo?> { get }
  var orderSide: EOrderSide { get }
  var state: ExchangeViewState { get set }
  var isMarketOrder: Bool { get }
  
  func calcFee() -> Decimal?
  func mainAction()
  func setSendAmount(_ amount: String?)
  func setReceiveAmount(_ amount: String?)
  func selectSendCoin(_ coin: ExchangeCoinViewItem)
  func selectReceiveCoin(_ coin: ExchangeCoinViewItem)
}
