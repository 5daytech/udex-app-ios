import Foundation

protocol IEnabledCoinsStorage {
  func getEnabledCoins() throws -> [EnabledCoin]
  func insertCoins(_ coins: [EnabledCoin]) throws
  func deleteAll() throws
}
