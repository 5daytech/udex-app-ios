import Foundation
import RxSwift

class BalanceLoader {
  let disposeBag = DisposeBag()
  
  private let coinManager: ICoinManager
  private let adaptersManager: IAdapterManager
  private let ratesManager: IRatesManager
  private let ratesConverter: RatesConverter
  
  let baseCoinCode = "ETH"
  
  let balancesSyncSubject = PublishSubject<Void>()
  var balances = [CoinBalance]()
  
  var totalBalance: TotalBalanceInfo
  
  init(coinManager: ICoinManager, adaptersManager: IAdapterManager, ratesManager: IRatesManager, ratesConverter: RatesConverter) {
    self.coinManager = coinManager
    self.adaptersManager = adaptersManager
    self.ratesManager = ratesManager
    self.ratesConverter = ratesConverter
    
    totalBalance = TotalBalanceInfo(
      coin: coinManager.getCoin(code: baseCoinCode),
      balance: 0,
      fiatBalance: 0
    )
    
    adaptersManager.adaptersUpdatedSignal.subscribe(onNext: {
      self.onRefreshAdapters()
    }).disposed(by: disposeBag)
    onRefreshAdapters()
  }
  
  func refresh() {
    adaptersManager.refresh()
    ratesManager.refresh()
  }
  
  private func onRefreshAdapters() {
    adaptersManager.balanceAdapters.forEach { (adapter) in
      print(adapter)
      adapter.stateUpdatedObservable.subscribe(onNext: {
        self.updateBalance()
      }).disposed(by: disposeBag)
      
      adapter.balanceUpdatedObservable.subscribe(onNext:  {
        self.updateBalance()
      }).disposed(by: disposeBag)
    }
    self.updateBalance()
  }
  
  private func updateBalance() {
    balances = coinManager.coins.map { coin -> CoinBalance in
      let adapter = adaptersManager.balanceAdapter(for: coin)!
      return CoinBalance(
        coin: coin,
        balance: adapter.balance,
        fiatBalance: ratesConverter.getCoinsPrice(
          code: coin.code,
          amount: adapter.balance
        ),
        pricePerToken: ratesConverter.getCoinPrice(code: coin.code),
        state: matchAdapterState(adapter: adapter),
        convertType: matchConvertType(coin: coin)
      )
    }
    updateTotalBalance()
    balancesSyncSubject.onNext(())
  }
  
  private func updateTotalBalance() {
    var totalFiat: Decimal = 0
    
    balances.forEach { (balance) in
      totalFiat += balance.fiatBalance
    }
    
    let balance = totalFiat / ratesConverter.getCoinPrice(code: baseCoinCode)
    
    totalBalance.balance = balance
    totalBalance.fiatBalance = totalFiat
  }
  
  private func matchAdapterState(adapter: IBalanceAdapter) -> BalanceState {
    switch adapter.state {
    case .notSynced:
      return .FAILED
    case .synced:
      return .SYNCED
    case .syncing:
      return .SYNCING
    }
  }
  
  private func matchConvertType(coin: Coin) -> EConvertType {
    switch coin.code {
    case "ETH":
      return .WRAP
    case "WETH":
      return .UNWRAP
    default:
      return .NONE
    }
  }
}
