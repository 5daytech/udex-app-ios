import Foundation
import BigInt
import RxSwift

class LimitExchangeViewModel: ExchangeViewModel {  
  override func initState(sendItem: ExchangeCoinViewItem?, receiveItem: ExchangeCoinViewItem?) {
//    state = LimitOrderViewState(sendAmount: 0, sendCoin: sendItem, receiveCoin: receiveItem)
  }
  
  func placeOrder() {
//    guard let state = state else { return }
    
    if state.sendAmount > 0 && priceInfo > 0 {
      let orderData = CreateOrderData(
        coinPair: marketCodes[currentMarketPosition],
        side: orderSide,
        amount: state.sendAmount,
        price: priceInfo
      )
      
      relayer.createOrder(createData: orderData)
        .observeOn(MainScheduler.instance)
        .subscribe(onError: { (err) in
          print("Error \(err)")
        }, onCompleted: {
          print("Order posted")
        })
      .disposed(by: disposeBag)
    }
  }
  
  override func updateReceiveAmount() {
//    guard let state = state else { return }
    let receiveAmount = state.sendAmount * priceInfo
    print(receiveAmount)
  }
}
