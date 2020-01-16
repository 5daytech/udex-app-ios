import RxSwift

protocol IAdapterManager: class {
  var adaptersUpdatedSignal: Observable<Void> { get }
  var balanceAdapters: [IBalanceAdapter] { get }
  func adapter(for coin: Coin) -> IAdapter?
  func balanceAdapter(for coin: Coin) -> IBalanceAdapter?
  func transactionsAdapter(for coin: Coin) -> ITransactionsAdapter?
  func refresh()
}
