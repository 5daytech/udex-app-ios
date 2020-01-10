import Foundation
import zrxkit

struct FillResult {
  let orders: [SignedOrder]
  let receiveAmount: Decimal
  let sendAmount: Decimal
  
  static func empty() -> FillResult {
    FillResult(orders: [], receiveAmount: 0, sendAmount: 0)
  }
}
