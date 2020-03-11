import Foundation
import SQLite
import SQLite3
import RxSwift

class EnabledCoinsDao: IEnabledCoinsStorage {
  let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
  let db: Connection
  let enabledCoins = Table("enabled_coins")
  let coinCode = Expression<String>("coin_code")
  let order = Expression<Int?>("order")
  
  var subject = PublishSubject<[EnabledCoin]>()
  
  var enabledCoinsObservable: Observable<[EnabledCoin]> {
    subject.asObservable()
  }
  
  init() {
    db = try! Connection("\(path)/udex.sqlite3")
    try! db.run(enabledCoins.create(ifNotExists: true) { t in
      t.column(coinCode, primaryKey: true)
      t.column(order)
    })
  }
  
  func insert(_ coin: EnabledCoin) throws {
    try db.run(enabledCoins.insert(coinCode <- coin.coinCode, order <- coin.order))
  }
  
  func getEnabledCoins() throws -> [EnabledCoin] {
    try (try db.prepare(enabledCoins.order(order.asc))).map { EnabledCoin(coinCode: try $0.get(coinCode), order: try $0.get(order)) }
  }
  
  func insertCoins(_ coins: [EnabledCoin]) throws {
    try deleteAll()
    try coins.forEach { try insert($0) }
    subject.onNext(coins)
  }
  
  func deleteAll() throws {
    try db.run(enabledCoins.delete())
  }
}
