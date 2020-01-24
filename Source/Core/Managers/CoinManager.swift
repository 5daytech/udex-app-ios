import Foundation
import RxSwift

class CoinManager {
  private let subject = PublishSubject<Void>()
  private var _coins: [Coin]
  private let baseCoins = ["BTC", "ETH"]
  private let appConfigProvider: IAppConfigProvider
  
  init(appConfigProvider: IAppConfigProvider) {
    self.appConfigProvider = appConfigProvider
    _coins = appConfigProvider.coins
    self.subject.onNext(())
  }
}

extension CoinManager: ICoinManager {
  var coins: [Coin] {
    return _coins
  }
  
  var coinsUpdateSubject: Observable<Void> {
    return subject.asObserver()
  }
  
  func enableDefaultCoins() {
    _coins = appConfigProvider.coins
  }
  
  func getErcCoinForAddress(address: String) -> Coin? {
    _coins.filter { coin -> Bool in
      switch coin.type {
      case .erc20(let filterAddress, _, _, _, _):
        return filterAddress.lowercased() == address.lowercased()
      case .ethereum:
        return false
      }
    }
    .first
  }
  
  func getCoin(code: String) -> Coin {
    let coinOrNull = _coins.first { (coin) -> Bool in
      coin.code == code
    }
    
    if coinOrNull != nil {
      return coinOrNull!
    } else {
      fatalError() // Throw exception
    }
  }
  
  func cleanCoinCode(coinCode: String) -> String {    
    let baseIndex = baseCoins.firstIndex { (baseCoin) -> Bool in
      coinCode.starts(with: "W") && coinCode.substr(1, coinCode.count - 1) == baseCoin
    }
    
    if baseIndex != nil {
      return baseCoins[baseIndex!]
    } else if coinCode == "SAI" {
      return "DAI"
    } else {
      return coinCode
    }
  }
  
  func clear() {
    _coins = []
  }
}
