import Foundation
import RxSwift

class BalanceViewModel: ObservableObject {
  let disposeBag = DisposeBag()
  
  var balanceLoader = BalanceLoader(
    coinManager: App.instance.coinManager,
    adaptersManager: App.instance.adapterManager,
    ratesManager: App.instance.ratesManager,
    ratesConverter: App.instance.ratesConverter
  )
  
  @Published var balances: [CoinBalance] = []
  
  init() {
    syncBalances()
    balanceLoader.balancesSyncSubject
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: {
        self.syncBalances()
      })
      .disposed(by: disposeBag)
  }
  
  private func syncBalances() {
    balances = balanceLoader.balances
  }
  
  func expand(for balance: BalanceViewItem) {
    
  }
  
  func refresh() {
    balanceLoader.refresh()
  }
}
