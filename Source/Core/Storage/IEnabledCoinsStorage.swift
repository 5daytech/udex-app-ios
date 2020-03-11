import Foundation
import RxSwift

protocol IEnabledCoinsStorage {
  func getEnabledCoins() throws -> [EnabledCoin]
  func insertCoins(_ coins: [EnabledCoin]) throws
  func deleteAll() throws
  
  var enabledCoinsObservable: Observable<[EnabledCoin]> { get }
}
