import Foundation
import zrxkit

struct NormalizedOrderData {
  let orderHash: String
  let makerCoin: Coin
  let takerCoin: Coin
  let makerAmount: Decimal
  let remainingMakerAmount: Decimal
  let takerAmount: Decimal
  let remainingTakerAmount: Decimal
  let price: Decimal
  let order: SignedOrder?
}
