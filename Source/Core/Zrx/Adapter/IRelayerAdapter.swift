import RxSwift
import zrxkit
import Web3

protocol IRelayerAdapter {
  var currentPair: ExchangePair { get }
  var exchangePairs: [ExchangePair] { get }
  var buyOrdersSubject: BehaviorSubject<[SignedOrder]> { get }
  var sellOrdersSubject: BehaviorSubject<[SignedOrder]> { get }
  
  func setSelected(baseCode: String, quoteCode: String)
  func createOrder(createData: CreateOrderData) -> Observable<SignedOrder>
  func fill(fillData: FillOrderData) -> Observable<EthereumData>
  func calculateFillAmount(coinPair: Pair<String, String>, side: EOrderSide, amount: Decimal) -> FillResult
  func calculateSendAmount(coinPair: Pair<String, String>, side: EOrderSide, amount: Decimal) -> FillResult
}
