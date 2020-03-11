import SwiftUI

class CoinManagerViewModel: ObservableObject {
  let coinManager = App.instance.coinManager
  let enabledCoinsStorage = App.instance.enabledCoinsStorage
  let allCoins: [Coin]
  
  @Published var enabledViewItems = [CoinManagerViewItem]()
  @Published var disabledViewItems = [CoinManagerViewItem]()
  
  var enabledCoins = [Coin]()
  var disabledCoins = [Coin]()
  
  init() {
    allCoins = coinManager.allCoins
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
    updateViewItems()
  }
  
  private func setDisablesCoin() {
    disabledCoins = allCoins.filter({ (coin) -> Bool in
      !enabledCoins.contains(coin)
    })
  }
  
  private func updateViewItems() {
    enabledViewItems = enabledCoins.map { CoinManagerViewItem(coin: $0, isEnabled: true) }
    disabledViewItems = disabledCoins.map { CoinManagerViewItem(coin: $0, isEnabled: false) }
  }
  
  func move(_ indexSet: IndexSet, _ index: Int) {
    enabledCoins.move(fromOffsets: indexSet, toOffset: index)
  }
  
  private func enable(_ coin: Coin) {
    enabledCoins.append(coin)
    setDisablesCoin()
    updateViewItems()
  }
  
  private func disable(_ coin: Coin) {
    enabledCoins.removeAll { $0.code == coin.code }
    setDisablesCoin()
    updateViewItems()
  }
  
  func onTapCoin(_ coin: Coin) {
    isEnabled(coin) ? disable(coin) : enable(coin)
  }
  
  func isEnabled(_ coin: Coin) -> Bool {
    return enabledCoins.contains(coin)
  }
  
  func saveCoins() {
    try! enabledCoinsStorage.insertCoins(enabledCoins.enumerated().map { EnabledCoin(coinCode: $0.element.code, order: $0.offset) })
  }
}
