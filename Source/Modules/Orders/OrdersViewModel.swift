import Foundation
import zrxkit
import RxSwift
import BigInt

class OrdersViewModel: ObservableObject {
  private let disposeBag = DisposeBag()
  @Published var sellOrders: [OrderViewItem] = []
  @Published var buyOrders: [OrderViewItem] = []
  @Published var currentPair: ExchangePairViewItem
  @Published var availablePairs: [ExchangePairViewItem] = []
  
  let relayerManager: IRelayerManager
  let relayerAdapter: IRelayerAdapter
  
  var relayer: Relayer {
    relayerManager.availableRelayers[0]
  }
  
  private let numberFormatter: NumberFormatter
  
  init(relayerManager: IRelayerManager, relayerAdapter: IRelayerAdapter) {
    self.relayerManager = relayerManager
    self.relayerAdapter = relayerAdapter
    
    self.currentPair = ExchangePairViewItem(
      baseCoin: relayerAdapter.exchangePairs[0].baseCoinCode,
      basePrice: 100.0,
      quoteCoin: relayerAdapter.exchangePairs[0].quoteCoinCode,
      quotePrice: 100.0
    )
    
    numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 4
  }
  
  func loadOrders() {
    let base = relayerAdapter.exchangePairs[0].baseAsset.assetData
    let quote = relayerAdapter.exchangePairs[0].quoteAsset.assetData
    relayerManager.getOrderbook(relayerId: 0, base: base, qoute: quote)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { (response) in
        self.sellOrders = response.asks.records.map { self.convert(signedOrder: $0.order, isBuy: false) }
        self.buyOrders = response.bids.records.map { self.convert(signedOrder: $0.order, isBuy: true) }
      }, onError: { (error) in
        Logger.e("OnError", error: error)
      }).disposed(by: disposeBag)
  }
  
  private func convert(signedOrder: SignedOrder, isBuy: Bool) -> OrderViewItem {
    let maker = Double(signedOrder.makerAssetAmount)! * pow(Double(10), Double(-18))
    let taker = Double(signedOrder.takerAssetAmount)! * pow(Double(10), Double(-18))
    
    return OrderViewItem(
      makerAmount: numberFormatter.string(from: NSNumber(value: maker))!,
      takerAmount: numberFormatter.string(from: NSNumber(value: taker))!,
      isBuy: isBuy)
  }
  
  private func refreshPairs() {
    
  }
}
