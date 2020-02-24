import Foundation
import UIKit

class ReceiveViewModel {
  
  let address: String
  let coin: Coin
  
  init(coin: Coin) {
    self.coin = coin
    address = App.instance.adapterManager.adapter(for: coin)!.receiveAddress
  }
}
