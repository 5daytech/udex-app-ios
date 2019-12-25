import RxSwift

class AdapterManager {
  private let disposeBag = DisposeBag()
  
  private let adapterFactory: IAdapterFactory
  private let ethereumKitManager: EthereumKitManager
  
  private let subject = PublishSubject<Void>()
  
  private let queue = DispatchQueue(label: "fridaytech.udex.adapter_manager", qos: .userInitiated)
  private var adapters = [Coin: IAdapter]()
  
  init(adapterFactory: IAdapterFactory, ethereumKitManager: EthereumKitManager, coins: [Coin], words: [String]) {
    self.adapterFactory = adapterFactory
    self.ethereumKitManager = ethereumKitManager
    initAdapters(coins: coins, words: words)
  }
  
  private func initAdapters(coins: [Coin], words: [String]) {
    var newAdapters = queue.sync { adapters }
    
    for coin in coins {
      guard newAdapters[coin] == nil else {
        continue
      }
      
      if let adapter = adapterFactory.adapter(coin: coin, words: words) {
        newAdapters[coin] = adapter
        adapter.start()
      }
    }
    
    var removedAdapters = [IAdapter]()
    
    for coin in Array(newAdapters.keys) {
      guard !coins.contains(coin), let adapter = newAdapters.removeValue(forKey: coin) else {
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
  
  var adaptersReadyObservable: Observable<Void> {
    subject.asObservable()
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
    
    ethereumKitManager.ethereumKit?.refresh()
  }
  
}
