import Foundation
import RxSwift

class BalanceViewModel: ObservableObject {
  let disposeBag = DisposeBag()
  
  let adapterManager: IAdapterManager
  
  @Published var balances: [Balance] = []
  
  let coins: [Coin]
  
  init(adapterManager: IAdapterManager, coins: [Coin]) {
    self.adapterManager = adapterManager
    self.coins = coins
    subscribeToAdapters()
  }
  
  func expand(for balance: Balance) {
    
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
      let row: Balance
      if let balance = adapterManager.balanceAdapter(for: coin)?.balance {
        row = Balance(balance: "\(balance)", expanded: false)
      } else {
        row = Balance(balance: "NAN", expanded: false)
      }
      balances.append(row)
    }
  }
}
