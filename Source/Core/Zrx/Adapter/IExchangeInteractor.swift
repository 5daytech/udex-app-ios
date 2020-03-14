import Foundation
import zrxkit
import RxSwift
import Web3

protocol IExchangeInteractor {
  func createOrder(feeRecipient: String, createData: CreateOrderData) -> Observable<SignedOrder>
  func fill(orders: [SignedOrder], fillData: FillOrderData) -> Observable<EthereumData>
  func ordersInfo(orders: [SignedOrder]) -> Observable<[OrderInfo]>
  func cancelOrders(orders: [SignedOrder]) -> Observable<EthereumData>
}
