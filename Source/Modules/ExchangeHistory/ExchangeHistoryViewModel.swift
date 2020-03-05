import Foundation
import RxSwift

class ExchangeHistoryViewModel: ObservableObject {
  private let disposeBag = DisposeBag()
  private let exchangeHistoryManager = App.instance.exchangeHistoryManager
  
  @Published var transactions = [ExchangeRecord]()
  
  init() {
    exchangeHistoryManager.syncSubject.observeOn(MainScheduler.instance).subscribe(onNext: {
      self.refreshTrades()
    }).disposed(by: disposeBag)
  }
  
  private func refreshTrades() {
    transactions = exchangeHistoryManager.exchangeHistory
  }
}
