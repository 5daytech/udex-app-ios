import Foundation
import zrxkit

struct SimpleOrder: Identifiable {
  var id = UUID().uuidString
  
  let makerCoin: Coin
  let takerCoin: Coin
  let price: Decimal
  let makerAmount: Decimal
  let remainingMakerAmount: Decimal
  let takerAmount: Decimal
  let remainingTakerAmount: Decimal
  let makerFiatAmount: Decimal
  let takerFiatAmount: Decimal
  let expireDate: String
  let side: EOrderSide
  let isMine: Bool
  let status: String
  let filledAmount: Decimal
  
  static func fromOrder(ratesConverter: RatesConverter, orderRecord: OrderRecord, side: EOrderSide, orderInfo: OrderInfo? = nil, isMine: Bool = false) -> SimpleOrder? {
    guard let normalizedData = OrdersUtil.normalizeOrderDataPrice(orderRecord: orderRecord) else {
      return nil
    }
    
    let status = orderInfo?.orderStatus != nil ? "\(orderInfo!.orderStatus)" : "unknown"
    
    return SimpleOrder(
      makerCoin: normalizedData.makerCoin,
      takerCoin: normalizedData.takerCoin,
      price: normalizedData.price,
      makerAmount: normalizedData.makerAmount,
      remainingMakerAmount: normalizedData.remainingMakerAmount,
      takerAmount: normalizedData.takerAmount,
      remainingTakerAmount: normalizedData.remainingTakerAmount,
      makerFiatAmount: ratesConverter.getCoinsPrice(code: normalizedData.makerCoin.code, amount: normalizedData.remainingMakerAmount),
      takerFiatAmount: ratesConverter.getCoinsPrice(code: normalizedData.takerCoin.code, amount: normalizedData.remainingTakerAmount),
      expireDate: "20 JAN, 7:00 AM", //TODO: Use time utils
      side: side,
      isMine: isMine,
      status: status,
      filledAmount: normalizedData.takerAmount - normalizedData.remainingTakerAmount
    )
  }
}
