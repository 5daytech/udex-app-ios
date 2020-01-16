import Foundation
import XRatesKit
import RxSwift

class RatesManager: IRatesManager {
  private let coinManager: ICoinManager
  private let currencyCode = "USD"
  private let kit: XRatesKit
  
  var getMarketsObservable: Observable<[String : MarketInfo]> {
    kit.marketInfosObservable(currencyCode: currencyCode)
  }
  
  init(coinManager: ICoinManager) {
    self.coinManager = coinManager
    kit = XRatesKit.instance(currencyCode: currencyCode, marketInfoExpirationInterval: 10 * 60)
    
    onCoinsUpdated(coins: coinManager.coins)
  }
  
  private func cleanCode(coinCode: String) -> String {
    coinManager.cleanCoinCode(coinCode: coinCode)
  }
  
  private func onCoinsUpdated(coins: [Coin]) {
    kit.set(coinCodes: coins.map { cleanCode(coinCode: $0.code) })
  }
  
  func getLatestRate(coinCode: String) -> Decimal? {
    let marketInfo = getMarketInfo(coinCode: coinCode)
    if marketInfo?.expired ?? true {
      return nil
    }
    return marketInfo?.rate
  }
  
  func getMarketInfo(coinCode: String) -> MarketInfo? {
    kit.marketInfo(coinCode: cleanCode(coinCode: coinCode), currencyCode: currencyCode)
  }
  
  func refresh() {
    kit.refresh()
  }
}
