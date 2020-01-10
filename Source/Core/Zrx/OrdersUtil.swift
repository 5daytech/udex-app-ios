import Foundation
import zrxkit

class OrdersUtil {
  static let coinManager = App.instance.coinManager
  
  static func normalizeOrderDataPrice(orderRecord: OrderRecord, isSellPrice: Bool = true) -> NormalizedOrderData {
    let makerCoin = coinManager.getErcCoinForAddress(address: EAssetProxyId.ERC20.decode(asset: orderRecord.order.makerAssetData))!
    let takerCoin = coinManager.getErcCoinForAddress(address: EAssetProxyId.ERC20.decode(asset: orderRecord.order.takerAssetData))!
    
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
}
