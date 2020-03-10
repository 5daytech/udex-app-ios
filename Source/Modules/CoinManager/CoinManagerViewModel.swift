import SwiftUI

class CoinManagerViewModel: ObservableObject {
  let coinManager = App.instance.coinManager
  let enabledCoinsStorage = App.instance.enabledCoinsStorage
  let allCoins: [Coin]
  
  @Published var enabledCoins = [Coin]()
  @Published var disabledCoins = [Coin]()
  
  init() {
    allCoins = coinManager.coins
    do {
      try enabledCoinsStorage.getEnabledCoins().forEach { enabledCoin in
        if let coin = self.coinManager.coins.first(where: { (coin) -> Bool in
          coin.code == enabledCoin.coinCode
        }) {
          self.enabledCoins.append(coin)
        }
      }
    } catch {}
    
    setDisablesCoin()
  }
  
  private func setDisablesCoin() {
    disabledCoins = allCoins.filter({ (coin) -> Bool in
      !enabledCoins.contains(coin)
    })
  }
  
  func move(_ indexSet: IndexSet, _ index: Int) {
    enabledCoins.move(fromOffsets: indexSet, toOffset: index)
  }
  
  private func enable(_ coin: Coin) {
    enabledCoins.append(coin)
    print("enable \(enabledCoins.count)")
    setDisablesCoin()
  }
  
  private func disable(_ coin: Coin) {
    enabledCoins.removeAll { $0.code == coin.code }
    print("disable \(enabledCoins.count)")
    setDisablesCoin()
  }
  
  func onTapCoin(_ coin: Coin) {
    isEnabled(coin) ? disable(coin) : enable(coin)
  }
  
  func isEnabled(_ coin: Coin) -> Bool {
    print("CHECK INABLED")
    return enabledCoins.contains(coin)
  }
}
