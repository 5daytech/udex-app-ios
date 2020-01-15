struct ExchangePairsInfo {
  let coins: [ExchangeCoinViewItem]
  var selectedCoin: ExchangeCoinViewItem? {
    set {
      _selectedCoin = newValue
      _selectedCoin?.state = .down
    }
    get {
      _selectedCoin
    }
  }
  
  private var _selectedCoin: ExchangeCoinViewItem?
  
  init(coins: [ExchangeCoinViewItem], selectedCoin: ExchangeCoinViewItem?) {
    self.coins = coins
    self.selectedCoin = selectedCoin
  }
}
