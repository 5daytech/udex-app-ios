import Foundation
import RxSwift

protocol IExchangeHistoryManager {
  var exchangeHistory: [ExchangeRecord] { get }
  var syncSubject: BehaviorSubject<Void> { get }
}
