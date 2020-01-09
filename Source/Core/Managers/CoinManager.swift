import Foundation

class CoinManager: ICoinManager {
  
  let coins: [Coin]
  
  init(appConfigProvider: IAppConfigProvider) {
    coins = appConfigProvider.coins
  }
  
  func getErcCoinForAddress(address: String) -> Coin? {
    coins.filter { coin -> Bool in
      switch coin.type {
      case .erc20(let filterAddress, _, _, _, _):
        return filterAddress == address
      case .ethereum:
        return false
      }
    }
    .first
  }
  
  func getCoin(code: String) -> Coin {
    let coinOrNull = coins.first { (coin) -> Bool in
      coin.code == code
    }
    
    if coinOrNull != nil {
      return coinOrNull!
    } else {
      fatalError() // Throw exception
    }
  }
}
