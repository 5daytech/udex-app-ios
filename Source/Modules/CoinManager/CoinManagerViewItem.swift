import Foundation

struct CoinManagerViewItem: Identifiable {
  let id = UUID().uuidString
  
  let coin: Coin
  var isEnabled: Bool
}
