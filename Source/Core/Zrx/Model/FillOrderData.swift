import Foundation
import zrxkit

struct FillOrderData {
  let coinPair: Pair<String, String>
  let side: EOrderSide
  let amount: Decimal
}
