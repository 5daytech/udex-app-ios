import Foundation
import RxSwift

class BalanceViewModel: ObservableObject {
  let disposeBag = DisposeBag()
  
  let adapterManager: IAdapterManager
  
  @Published var balances: [BalanceViewItem] = []
  
  let coins: [Coin]
  let numberFormatter: NumberFormatter
  
  init(adapterManager: IAdapterManager, coins: [Coin]) {
    self.adapterManager = adapterManager
    self.coins = coins
    
    numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 4
    subscribeToAdapters()
  }
  
  func expand(for balance: BalanceViewItem) {
    
  }
  
  private func subscribeToAdapters() {
    for coin in coins {
      guard let adapter = adapterManager.balanceAdapter(for: coin) else {
        continue
      }
      
      adapter.balanceUpdatedObservable
        .subscribe(onNext: { [weak self] in
          self?.updateBalances()
        })
        .disposed(by: disposeBag)
      updateBalances()
    }
  }
  
  private func updateBalances() {
    balances = []
    for coin in coins {
      let balance = adapterManager.balanceAdapter(for: coin)?.balance ?? 0
      let converted = numberFormatter.string(from: balance as NSDecimalNumber)!
      let row = BalanceViewItem(title: coin.title, balance: converted, code: coin.code, expanded: false)
      balances.append(row)
    }
  }
}
