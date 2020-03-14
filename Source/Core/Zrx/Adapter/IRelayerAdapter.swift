import RxSwift
import zrxkit
import Web3

protocol IRelayerAdapter {
  var currentPair: ExchangePair? { get }
  var exchangePairs: [ExchangePair] { get }
  var myOrdersSubject: BehaviorSubject<[SimpleOrder]> { get }
  var buyOrdersSubject: BehaviorSubject<[SimpleOrder]> { get }
  var sellOrdersSubject: BehaviorSubject<[SimpleOrder]> { get }
  
  func setSelected(baseCode: String, quoteCode: String)
  func createOrder(createData: CreateOrderData) -> Observable<SignedOrder>
  func fill(fillData: FillOrderData) -> Observable<EthereumData>
  func cancelOrders() -> Observable<EthereumData>
  func calculateBasePrice(coinPair: Pair<String, String>, side: EOrderSide) -> Decimal
  func calculateFillAmount(coinPair: Pair<String, String>, side: EOrderSide, amount: Decimal) -> FillResult
  func calculateSendAmount(coinPair: Pair<String, String>, side: EOrderSide, amount: Decimal) -> FillResult
}
