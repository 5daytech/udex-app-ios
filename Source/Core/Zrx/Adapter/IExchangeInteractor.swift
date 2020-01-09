import Foundation
import zrxkit
import RxSwift

protocol IExchangeInteractor {
  func createOrder(feeRecipient: String, createData: CreateOrderData) -> Observable<SignedOrder>
}
