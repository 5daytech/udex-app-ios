import RxSwift
import zrxkit

protocol IRelayerAdapter {
  var currentPair: ExchangePair { get }
  var exchangePairs: [ExchangePair] { get }
  var buyOrdersSubject: BehaviorSubject<[SignedOrder]> { get }
  var sellOrdersSubject: BehaviorSubject<[SignedOrder]> { get }
  
  func setSelected(baseCode: String, quoteCode: String)
}
