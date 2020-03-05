import Foundation
import RxSwift

class ExchangeHistoryViewModel: ObservableObject {
  private let disposeBag = DisposeBag()
  private let exchangeHistoryManager = App.instance.exchangeHistoryManager
  
  init() {
    exchangeHistoryManager.syncSubject.observeOn(MainScheduler.instance).subscribe(onNext: {
      self.refreshTrades()
    }).disposed(by: disposeBag)
  }
  
  
  
  private func refreshTrades() {
    print(exchangeHistoryManager.exchangeHistory)
  }
}
