import Foundation
import RxSwift
import XRatesKit

protocol IRatesManager {
  var getMarketsObservable: Observable<[String: MarketInfo]> { get }
  
  func getLatestRate(coinCode: String) -> Decimal?
  func getHistoricalRate(coinCode: String, date: Date) -> Single<Decimal>
  func refresh()
}
