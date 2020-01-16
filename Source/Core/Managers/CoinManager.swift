import Foundation
import RxSwift

class CoinManager {
  private let subject = PublishSubject<Void>()
  private let _coins: [Coin]
  
  init(appConfigProvider: IAppConfigProvider) {
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
  
}
