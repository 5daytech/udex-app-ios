import Foundation

class RatesConverter {
  private let baseCoinCode = "ETH"
  private let ratesManager: IRatesManager
  
  init(ratesManager: IRatesManager) {
    self.ratesManager = ratesManager
  }
  
  private func getCoinRate(code: String) -> Decimal {
    ratesManager.getLatestRate(coinCode: code) ?? 0
  }
  
  func getCoinsPrice(code: String, amount: Decimal) -> Decimal {
    let rate = getCoinRate(code: code)
    return rate * amount
  }
  
  func getCoinPrice(code: String) -> Decimal {
    getCoinRate(code: code)
  }
}
