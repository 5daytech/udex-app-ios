import zrxkit

struct CreateOrderData {
  let coinPair: Pair<String, String>
  let side: EOrderSide
  let amount: Decimal
  let price: Decimal
}
