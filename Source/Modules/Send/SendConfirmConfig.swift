import Foundation

struct SendConfirmConfig {
  let sendAmount: Decimal
  let coin: Coin
  let sendAmountInFiat: Decimal
  let estimatedFee: Decimal
  let processingTime: Int
  let totalFiat: Decimal
  let receiveAddress: String
}
