import Foundation

protocol ICoinManager {
  var coins: [Coin] { get }
  
  func getErcCoinForAddress(address: String) -> Coin?
  func getCoin(code: String) -> Coin
}
