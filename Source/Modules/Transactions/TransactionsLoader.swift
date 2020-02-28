import Foundation
import RxSwift

class TransactionsLoader {
  private let disposeBag = DisposeBag()
  private let pageLimit = 50
  var transactions = [TransactionRecord]() {
    didSet {
      syncTransactions.onNext(transactions)
    }
  }
  
  private var loading = false
  private var allLoaded = false
  
  private let adapter: ITransactionsAdapter
  
  var syncTransactions = PublishSubject<[TransactionRecord]>()
  
  init(adapter: ITransactionsAdapter) {
    self.adapter = adapter
    self.adapter.transactionRecordsObservable.subscribe(onNext: { _ in
      self.loadNext()
    }).disposed(by: disposeBag)
    
    loadNext()
  }
  
  private func loadNext() {
    if (loading || allLoaded) { return }
    loading = true
    adapter.transactionsSingle(from: transactions.last, limit: pageLimit).subscribe(onSuccess: { (transactions) in
      self.allLoaded = transactions.isEmpty
      self.transactions.append(contentsOf: transactions)
      self.loading = false
    }).disposed(by: disposeBag)
  }
}
