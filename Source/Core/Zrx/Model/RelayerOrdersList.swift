import Foundation
import RxSwift

class RelayerOrdersList<T> {
  private var allPairOrders: [RelayerOrders<T>] = []
  
  var pairUpdateSubject = BehaviorSubject<RelayerOrders<T>>(value: RelayerOrders<T>(baseAsset: "", quoteAsset: "", orders: []))
  
  func getPair(baseAsset: String, quoteAsset: String) -> RelayerOrders<T> {
    allPairOrders.first{ $0.baseAsset == baseAsset && $0.quoteAsset == quoteAsset } ?? RelayerOrders(baseAsset: baseAsset, quoteAsset: quoteAsset, orders: [])
  }
  
  func updatePairOrders(baseAsset: String, quoteAsset: String, orders: [T]) {
    let index = allPairOrders.firstIndex { $0.baseAsset == baseAsset && $0.quoteAsset == quoteAsset }
    
    let newPair = RelayerOrders(baseAsset: baseAsset, quoteAsset: quoteAsset, orders: orders)
    
    if let index = index {
      allPairOrders[index] = newPair
    } else {
      allPairOrders.append(newPair)
    }
    
    pairUpdateSubject.onNext(newPair)
  }
  
  func clear() {
    allPairOrders.removeAll()
  }
  
}
