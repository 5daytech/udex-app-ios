import RxSwift

protocol IAdapterManager: class {
  var adaptersUpdatedSignal: Observable<Void> { get }
  var balanceAdapters: [IBalanceAdapter] { get }
  var transactionsAdapters: [ITransactionsAdapter] { get }
  func adapter(for coin: Coin) -> IAdapter?
  func balanceAdapter(for coin: Coin) -> IBalanceAdapter?
  func sendAdapter(for coin: Coin) -> ISendEthereumAdapter?
  func transactionsAdapter(for coin: Coin) -> ITransactionsAdapter?
  func refresh()
  func stopKits()
}
