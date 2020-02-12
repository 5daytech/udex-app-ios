import Foundation
import RxSwift

class LimitInteractor: BaseInteractor {
  override internal var title: String { "PLACE ORDER" }
  
  override internal var isMarket: Bool { false }
  
  override internal func action() {
    if state.sendAmount > 0 && state.receiveAmount > 0 {
      let orderData = CreateOrderData(
        coinPair: marketCodes[currentMarketPosition],
        side: orderSide == .BUY ? .SELL : .BUY,
        amount: state.sendAmount,
        price: state.receiveAmount
      )

      relayer?.createOrder(createData: orderData)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { _ in
          self.actionSubject.onNext(nil)
        }, onError: { (err) in
          self.actionSubject.onError(err)
        })
      .disposed(by: disposeBag)
    }
  }
  
  override internal func updateSendAmount() {
    state.receiveAdditional = state.receiveAmount * state.sendAmount
  }
  
  override internal func updateReceiveAmount() {
    state.receiveAdditional = state.receiveAmount * state.sendAmount
  }
  
  override func feeCalculation() -> Decimal? { nil }
}
