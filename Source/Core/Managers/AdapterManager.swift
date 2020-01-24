import RxSwift

class AdapterManager {
  private let disposeBag = DisposeBag()
  
  private let adapterFactory: IAdapterFactory
  private let ethereumKitManager: EthereumKitManager
  private let coinManager: ICoinManager
  private let authManager: IAuthManager
  
  
  private let subject = PublishSubject<Void>()
  
  private var adapters = [Coin: IAdapter]()
  
  init(coinManager: ICoinManager, adapterFactory: IAdapterFactory, ethereumKitManager: EthereumKitManager, authManager: IAuthManager) {
    self.coinManager = coinManager
    self.adapterFactory = adapterFactory
    self.ethereumKitManager = ethereumKitManager
    self.authManager = authManager
    
//    coinManager.coinsUpdateSubject.subscribe(onNext: {
//      self.initAdapters()
//    }).disposed(by: disposeBag)
    
    authManager.authDataSubject.subscribe(onNext: {
      self.initAdapters()
    }).disposed(by: disposeBag)
    
    initAdapters()
    
    let scheduler = SerialDispatchQueueScheduler(qos: .background)
    _ = Observable<Int>.interval(.microseconds(30_000_000), scheduler: scheduler)
      .subscribe { _ in
        self.refresh()
    }
  }
  
  private func initAdapters() {
    var newAdapters: [Coin : IAdapter] = [:]
    
    if let data = authManager.authData {
      coinManager.coins.forEach { coin in
        if newAdapters[coin] == nil {
          if let adapter = adapterFactory.adapter(coin: coin, authData: data) {
            newAdapters[coin] = adapter
            adapter.start()
          }
        }
      }
    }
    
    var removedAdapters = [IAdapter]()
    for coin in Array(newAdapters.keys) {
      guard !coinManager.coins.contains(coin), let adapter = newAdapters.removeValue(forKey: coin) else {
        continue
      }
      
      removedAdapters.append(adapter)
    }
    
    
    
    
    adapters = newAdapters
    subject.onNext(())
    
    
    removedAdapters.forEach { adapter in
      adapter.stop()
    }
  }
  
}

extension AdapterManager: IAdapterManager {
  var adaptersUpdatedSignal: Observable<Void> {
    subject.asObservable()
  }
  
  var balanceAdapters: [IBalanceAdapter] {    
    adapters.values.map { $0 as! IBalanceAdapter }
  }
  
  func adapter(for coin: Coin) -> IAdapter? {
    adapters[coin]
  }
  
  func balanceAdapter(for coin: Coin) -> IBalanceAdapter? {
    adapters[coin] as? IBalanceAdapter
  }
  
  func transactionsAdapter(for coin: Coin) -> ITransactionsAdapter? {
    adapters[coin] as? ITransactionsAdapter
  }
  
  func refresh() {
    for adapter in self.adapters.values {
      adapter.refresh()
    }
    
    ethereumKitManager.refresh()
  }
  
  func stopKits() {
    adapters.values.forEach { (adapter) in
      adapter.stop()
    }
    adapters = [:]
    subject.onNext(())
  }
}
