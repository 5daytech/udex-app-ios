import Foundation
import RxSwift

class MarketInteractor: BaseInteractor {
  override internal var title: String { "EXCHANGE" }
  override internal var isMarket: Bool { true }
  
  override internal func action() {
    if state.sendAmount > 0 && state.receiveAmount > 0 {
      let fillData = FillOrderData(
        coinPair: marketCodes[currentMarketPosition],
        side: orderSide,
        amount: state.receiveAmount
      )
      relayer?.fill(fillData: fillData).observeOn(MainScheduler.instance).subscribe(onNext: { (ethData) in
        self.actionSubject.onNext(ethData)
      }, onError: { (err) in
        self.actionSubject.onError(err)
      }).disposed(by: disposeBag)
    }
  }
  
  override internal func updateReceiveAmount() {
    guard let relayer = relayer else { return }
    let currentMarket = currentMarketPosition
    if currentMarket < 0 { return }
    
    let fillResult = relayer.calculateFillAmount(
      coinPair: marketCodes[currentMarket],
      side: orderSide,
      amount: state.sendAmount
    )
    
    let roundedReceiveAmount = fillResult.receiveAmount.toDisplayFormat()
    state.receiveAmount = Decimal(string: roundedReceiveAmount) ?? 0
    if state.sendAmount > fillResult.sendAmount {
      state.sendAvailableAmount = fillResult.sendAmount
    } else {
      state.sendAvailableAmount = nil
    }
    state.receiveAvailableAmount = nil
    receiveAmountSubject.onNext("\(state.receiveAmount)")
  }
  
  override internal func updateSendAmount() {
    guard let relayer = relayer else { return }
    let currentMarket = currentMarketPosition
    if currentMarket < 0 { return }
    
    let fillResult = relayer.calculateSendAmount(
      coinPair: marketCodes[currentMarket],
      side: orderSide,
      amount: state.receiveAmount
    )
    
    let roundedSendAmount = fillResult.sendAmount.toDisplayFormat()
    state.sendAmount = Decimal(string: roundedSendAmount) ?? 0
    if state.receiveAmount > fillResult.receiveAmount {
      state.receiveAvailableAmount = fillResult.receiveAmount
    } else {
      state.receiveAvailableAmount = nil
    }
    state.sendAvailableAmount = nil
    sendAmountSubject.onNext("\(state.sendAmount)")
  }
}
