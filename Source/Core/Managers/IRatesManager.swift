import Foundation
import RxSwift
import XRatesKit

protocol IRatesManager {
  var getMarketsObservable: Observable<[String: MarketInfo]> { get }
  
  func getLatestRate(coinCode: String) -> Decimal?
  func refresh()
}
