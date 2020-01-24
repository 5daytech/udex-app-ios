import Foundation
import zrxkit

class OrdersUtil {
  static let coinManager = App.instance.coinManager
  
  private static func getErcCoin(coinCode: String) -> Coin {
    coinManager.getCoin(code: coinCode)
  }
  
  static func normalizeOrderDataPrice(orderRecord: OrderRecord, isSellPrice: Bool = true) -> NormalizedOrderData? {
    guard let makerCoin = coinManager.getErcCoinForAddress(address: EAssetProxyId.ERC20.decode(asset: orderRecord.order.makerAssetData)) else { return nil }
    guard let takerCoin = coinManager.getErcCoinForAddress(address: EAssetProxyId.ERC20.decode(asset: orderRecord.order.takerAssetData)) else { return nil }
    
    let makerAmount = orderRecord.order.makerAssetAmount.normalizeToDecimal(decimal: -makerCoin.decimal)
    let takerAmount = orderRecord.order.takerAssetAmount.normalizeToDecimal(decimal: -takerCoin.decimal)
    
    let remainingTakerAmount = orderRecord.metaData.remainingFillableTakerAssetAmount?.normalizeToDecimal(decimal: -takerCoin.decimal) ?? 0
    let remainingMakerAmount = remainingTakerAmount > 0 ? makerAmount * (remainingTakerAmount / takerAmount) : 0
    
    let price = isSellPrice ? makerAmount / takerAmount : takerAmount / makerAmount
    
    return NormalizedOrderData(
      orderHash: orderRecord.metaData.orderHash,
      makerCoin: makerCoin,
      takerCoin: takerCoin,
      makerAmount: makerAmount,
      remainingMakerAmount: remainingMakerAmount,
      takerAmount: takerAmount,
      remainingTakerAmount: remainingTakerAmount,
      price: price,
      order: orderRecord.order
    )
  }
  
  static func calculateBasePrice(orders: [SignedOrder], coinPair: Pair<String, String>, side: EOrderSide) -> Decimal {
    calculateOrderPrice(coinPair: coinPair, order: orders.first!, side: side)
  }
  
  static func calculateOrderPrice(coinPair: Pair<String, String>, order: IOrder, side: EOrderSide) -> Decimal {
    let baseCoin = getErcCoin(coinCode: coinPair.first)
    let quoteCoin = getErcCoin(coinCode: coinPair.second)
    
    let makerAmount = order.makerAssetAmount.normalizeToDecimal(decimal: -(side == .BUY ? quoteCoin.decimal : baseCoin.decimal))
    
    let takerAmount = order.takerAssetAmount.normalizeToDecimal(decimal: -(side == .BUY ? baseCoin.decimal : quoteCoin.decimal))
    
    return makerAmount / takerAmount
  }
}
