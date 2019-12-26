import Foundation
import zrxkit
import RxSwift
import BigInt

class OrdersViewModel: ObservableObject {
  private let disposeBag = DisposeBag()
  @Published var sellOrders: [OrderViewItem] = []
  @Published var buyOrders: [OrderViewItem] = []
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
    
    relayerAdapter.buyOrdersSubject.subscribe(onNext: { signedOrders in
      self.buyOrders = signedOrders.map { self.convert(signedOrder: $0, isBuy: true) }
    }).disposed(by: disposeBag)
    
    relayerAdapter.sellOrdersSubject.subscribe(onNext: { signedOrders in
      self.sellOrders = signedOrders.map { self.convert(signedOrder: $0, isBuy: false) }
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
