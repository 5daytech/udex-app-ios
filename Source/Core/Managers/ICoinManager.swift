import Foundation
import RxSwift

protocol ICoinManager {
  var coins: [Coin] { get }
  var coinsUpdateSubject: Observable<Void> { get }
  
  func getErcCoinForAddress(address: String) -> Coin?
  func getCoin(code: String) -> Coin
  func cleanCoinCode(coinCode: String) -> String
}
