import Foundation
import zrxkit
import RxSwift
import BigInt

class OrdersViewModel: ObservableObject {
  private let disposeBag = DisposeBag()
  @Published var sellOrders: [SimpleOrder] = []
  @Published var buyOrders: [SimpleOrder] = []
  @Published var myOrders: [SimpleOrder] = []
  @Published var availablePairs: [ExchangePairViewItem]
  
  var isExpanded: Bool {
    availablePairs.count != 1
  }
  
  let relayerAdapter: IRelayerAdapter
  
  private let numberFormatter: NumberFormatter
  
  init(relayerAdapter: IRelayerAdapter) {
    
    self.relayerAdapter = relayerAdapter
    
    availablePairs = [ExchangePairViewItem(
      baseCoin: relayerAdapter.currentPair.baseCoinCode,
      basePrice: 100.0,
      quoteCoin: relayerAdapter.currentPair.quoteCoinCode,
      quotePrice: 100.0
    )]
    
    numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 4
    
    relayerAdapter.buyOrdersSubject.subscribe(onNext: { simpleOrders in
      self.buyOrders = simpleOrders
    }).disposed(by: disposeBag)
    
    relayerAdapter.sellOrdersSubject.subscribe(onNext: { simpleOrders in
      self.sellOrders = simpleOrders
    }).disposed(by: disposeBag)
    
    relayerAdapter.myOrdersSubject.observeOn(MainScheduler.instance).subscribe(onNext: { simpleOrders in
      self.myOrders = simpleOrders
    }).disposed(by: disposeBag)
  }
  
  private func convert(signedOrder: SignedOrder, isBuy: Bool) -> OrderViewItem {
    let maker = signedOrder.makerAssetAmount.normalizeToDecimal(decimal: -18)
    let taker = signedOrder.takerAssetAmount.normalizeToDecimal(decimal: -18)
    
    return OrderViewItem(
      makerAmount: numberFormatter.string(from: NSNumber(value: (maker as NSDecimalNumber).doubleValue))!,
      takerAmount: numberFormatter.string(from: NSNumber(value: (taker as NSDecimalNumber).doubleValue))!,
      isBuy: isBuy)
  }
  
  func onChoosePair(pair: ExchangePairViewItem) {
    if availablePairs.count == 1 {
      availablePairs.append(
        contentsOf: relayerAdapter.exchangePairs
          .filter { exchangePair -> Bool in
            !(exchangePair.baseCoinCode == availablePairs[0].baseCoin && exchangePair.quoteCoinCode == availablePairs[0].quoteCoin)
          }
          .map {
            ExchangePairViewItem(
              baseCoin: $0.baseCoinCode,
              basePrice: 100.0,
              quoteCoin: $0.quoteCoinCode,
              quotePrice: 100.0
            )
          }
      )
    } else {
      availablePairs = [pair]
    }    
    relayerAdapter.setSelected(baseCode: pair.baseCoin, quoteCode: pair.quoteCoin)
  }
}
