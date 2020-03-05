import Foundation
import RxSwift

class ExchangeHistoryManager: IExchangeHistoryManager {
  private let disposeBag = DisposeBag()
  
  var exchangeHistory: [ExchangeRecord] {
    exchangeTransactions.values.sorted { $0.date > $1.date }
  }
  
  var syncSubject: BehaviorSubject<Void> = BehaviorSubject(value: ())
  
  private var exchangeTransactions = [String: ExchangeRecord]()
  private var transactionsPool = [String: [TransactionRecord]]()
  
  private let adapterManager: IAdapterManager
  
  init(_ adapterManager: IAdapterManager) {
    self.adapterManager = adapterManager
    self.adapterManager.adaptersUpdatedSignal.subscribe(onNext: {
      self.subscribeToAdapters()
    }).disposed(by: disposeBag)
  }
  
  private func subscribeToAdapters() {
    adapterManager.transactionsAdapters.forEach { adapter in
      transactionsPool[adapter.coinCode] = []
      adapter.transactionsSingle(from: nil, limit: 400).subscribe(onSuccess: { (transactionRecords) in
        self.refreshTransactionsPool(adapter.coinCode, transactionRecords)
      }).disposed(by: disposeBag)
    }
  }
  
  private func refreshTransactionsPool(_ code: String, _ transactionRecords: [TransactionRecord]) {
    transactionsPool[code]?.append(contentsOf: transactionRecords)
    
    transactionsPool.forEach { coinTransactions in
      coinTransactions.value.forEach { (transaction) in
        var tradeTx = [ExchangeRecordItem]()
        transactionsPool.forEach { otherCoinsTx in
          otherCoinsTx.value.filter { $0.blockHeight == transaction.blockHeight && $0.transactionIndex == transaction.transactionIndex }.forEach { (filteredTx) in
            tradeTx.append(ExchangeRecordItem(coinCode: otherCoinsTx.key, transactionRecord: filteredTx))
          }
        }
        if tradeTx.count > 1 {
          var allItemsIdentical = true
          tradeTx.forEach { (item) in
            if (item.coinCode != tradeTx[0].coinCode) {
              allItemsIdentical = false
            }
          }
          
          if !allItemsIdentical {
            if (exchangeTransactions[transaction.transactionHash] == nil) {
              exchangeTransactions[transaction.transactionHash] = ExchangeRecord(
                hash: transaction.transactionHash,
                date: transaction.date,
                fromCoins: tradeTx,
                toCoins: [])
            }
          }
        }
      }
    }
    
    syncSubject.onNext(())
  }
}
