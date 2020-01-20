import RxSwift

class AdapterManager {
  private let disposeBag = DisposeBag()
  
  private let adapterFactory: IAdapterFactory
  private let ethereumKitManager: EthereumKitManager
  private let coinManager: ICoinManager
  private let words: [String]
  
  
  private let subject = PublishSubject<Void>()
  
  private let queue = DispatchQueue(label: "fridaytech.udex.adapter_manager", qos: .userInitiated)
  private var adapters = [Coin: IAdapter]()
  
  init(coinManager: ICoinManager, adapterFactory: IAdapterFactory, ethereumKitManager: EthereumKitManager, words: [String]) {
    self.coinManager = coinManager
    self.adapterFactory = adapterFactory
    self.ethereumKitManager = ethereumKitManager
    self.words = words
    
//    coinManager.coinsUpdateSubject.subscribe(onNext: {
//      self.initAdapters()
//    }).disposed(by: disposeBag)
    
    initAdapters()
    
    let scheduler = SerialDispatchQueueScheduler(qos: .background)
    _ = Observable<Int>.interval(.microseconds(30_000_000), scheduler: scheduler)
      .subscribe { _ in
        self.refresh()
    }
  }
  
  private func initAdapters() {
    var newAdapters = adapters
    
    coinManager.coins.forEach { coin in
      if newAdapters[coin] == nil {
        if let adapter = adapterFactory.adapter(coin: coin, words: words) {
          newAdapters[coin] = adapter
          adapter.start()
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
    
    
    
    queue.async {
      self.adapters = newAdapters
      self.subject.onNext(())
    }
    
    removedAdapters.forEach { adapter in
      adapter.stop()
    }
  }
  
}

extension AdapterManager: IAdapterManager {
  var adaptersUpdatedSignal: Observable<Void> {
    queue.sync { subject.asObservable() }
  }
  
  var balanceAdapters: [IBalanceAdapter] {    
    queue.sync { adapters.values.map { $0 as! IBalanceAdapter } }
  }
  
  func adapter(for coin: Coin) -> IAdapter? {
    queue.sync { adapters[coin] }
  }
  
  func balanceAdapter(for coin: Coin) -> IBalanceAdapter? {
    queue.sync { adapters[coin] as? IBalanceAdapter }
  }
  
  func transactionsAdapter(for coin: Coin) -> ITransactionsAdapter? {
    queue.sync { adapters[coin] as? ITransactionsAdapter }
  }
  
  func refresh() {
    queue.async {
      for adapter in self.adapters.values {
        adapter.refresh()
      }
    }
    
    ethereumKitManager.refresh()
  }
  
}
