import Foundation

struct RelayerOrders<T> {
  let baseAsset: String
  let quoteAsset: String
  let orders: [T]
}
