import Foundation
import RxSwift

class BalanceViewModel {
  let disposeBag = DisposeBag()
  
  var balanceLoader = BalanceLoader(
    coinManager: App.instance.coinManager,
    adaptersManager: App.instance.adapterManager,
    ratesManager: App.instance.ratesManager,
    ratesConverter: App.instance.ratesConverter
  )
  
  var balances: [CoinBalance] = []
  var totalBalance: TotalBalanceInfo
  
  var balancesSubject = PublishSubject<Void>()
  
  init() {
    totalBalance = TotalBalanceInfo(coin: App.instance.coinManager.getCoin(code: "ETH"), balance: 0, fiatBalance: 0)
    syncBalances()
    balanceLoader.balancesSyncSubject
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: {
        self.syncBalances()
      })
      .disposed(by: disposeBag)
  }
  
  private func syncBalances() {
    balancesSubject.onNext(())
    balances = balanceLoader.balances
    totalBalance = balanceLoader.totalBalance
  }
  
  func expand(for balance: BalanceViewItem) {
    
  }
  
  func refresh() {
    balanceLoader.refresh()
  }
  
  
}
