import Foundation
import zrxkit
import RxSwift

class BaseRelayerAdapter: IRelayerAdapter {
  let disposeBag = DisposeBag()
  private let relayerId: Int
  private let relayerManager: IRelayerManager
  private let relayer: Relayer
  
  private var selectedPair: ExchangePair
  
  var currentPair: ExchangePair {
    selectedPair
  }
  
  let exchangeInteractor: IExchangeInteractor
  var exchangePairs: [ExchangePair] = []
  var buyOrdersSubject = BehaviorSubject<[SignedOrder]>(value: [])
  var sellOrdersSubject = BehaviorSubject<[SignedOrder]>(value: [])
  
  init(zrxkit: ZrxKit, coinManager: ICoinManager, exchangeInteractor: IExchangeInteractor, refreshInterval: Int, relayerId: Int) {
    self.exchangeInteractor = exchangeInteractor
    self.relayerId = relayerId
    self.relayerManager = zrxkit.relayerManager
    self.relayer = relayerManager.availableRelayers[relayerId]
    let pair = relayerManager.availableRelayers[relayerId].availablePairs[0]
    self.selectedPair = ExchangePair(
      baseCoinCode: coinManager.getErcCoinForAddress(address: pair.first.address)!.code,
      quoteCoinCode: coinManager.getErcCoinForAddress(address: pair.second.address)!.code,
      baseAsset: pair.first,
      quoteAsset: pair.second
    )
    initPairs(relayer: relayerManager.availableRelayers[relayerId], coinManager: coinManager)
    
    let scheduler = SerialDispatchQueueScheduler(qos: .background)
    _ = Observable<Int>.interval(.microseconds(refreshInterval), scheduler: scheduler)
      .subscribe { _ in
        self.refreshOrders(
          relayerManager: self.relayerManager,
          relayerId: self.relayerId,
          pair: self.selectedPair
        )
      }
    self.refreshOrders(relayerManager: relayerManager, relayerId: relayerId, pair: selectedPair)
  }
  
  private func initPairs(relayer: Relayer, coinManager: ICoinManager) {
    exchangePairs = relayer.availablePairs
    .filter { pair -> Bool in
      let baseCoin = coinManager.getErcCoinForAddress(address: pair.first.address)
      let quoteCoin = coinManager.getErcCoinForAddress(address: pair.second.address)
      return baseCoin != nil && quoteCoin != nil
    }
    .map { pair -> ExchangePair in
      ExchangePair(
        baseCoinCode: coinManager.getErcCoinForAddress(address: pair.first.address)?.code ?? "",
        quoteCoinCode: coinManager.getErcCoinForAddress(address: pair.second.address)?.code ?? "",
        baseAsset: pair.first,
        quoteAsset: pair.second
      )
    }
  }
  
  private func refreshOrders(
    relayerManager: IRelayerManager,
    relayerId: Int,
    pair: ExchangePair
  ) {
    relayerManager.getOrderbook(
      relayerId: relayerId,
      base: pair.baseAsset.assetData,
      qoute: pair.quoteAsset.assetData
    )
    .subscribe(onNext: { response in
      self.buyOrdersSubject.onNext(response.bids.records.map { $0.order })
      self.sellOrdersSubject.onNext(response.asks.records.map { $0.order })
    })
    .disposed(by: disposeBag)
  }
  
  func setSelected(baseCode: String, quoteCode: String) {
    selectedPair = exchangePairs.filter { $0.baseCoinCode == baseCode && $0.quoteCoinCode == quoteCode }.first!
    refreshOrders(
      relayerManager: relayerManager,
      relayerId: relayerId,
      pair: selectedPair
    )
  }
  
  func createOrder(createData: CreateOrderData) -> Observable<SignedOrder> {
    exchangeInteractor.createOrder(feeRecipient: relayer.feeRecipients.first!, createData: createData)
  }
}
