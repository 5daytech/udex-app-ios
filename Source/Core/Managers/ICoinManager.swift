import Foundation
import RxSwift

protocol ICoinManager {
  var coins: [Coin] { get }
  var allCoins: [Coin] { get }
  var coinsUpdateSubject: Observable<Void> { get }
  
  func enableDefaultCoins()
  func getErcCoinForAddress(address: String) -> Coin?
  func getCoin(code: String) -> Coin
  func cleanCoinCode(coinCode: String) -> String
  func clear()
}
