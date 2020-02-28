import Foundation
import SwiftUI
import RxSwift

class TransactionsViewModel: ObservableObject {
  private let disposeBag = DisposeBag()
  private let transactionsLoader: TransactionsLoader
  private let coin: Coin
  private let adapter: IAdapter
  private let rateConverter = App.instance.ratesConverter
  
  @Published var transactions = [TransactionViewItem]()
  
  init(coin: Coin) {
    self.coin = coin
    let adapter = App.instance.adapterManager.transactionsAdapter(for: coin)!
    self.adapter = adapter as! IAdapter
    transactionsLoader = TransactionsLoader(adapter: adapter)
    transactionsLoader.syncTransactions.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { transactions in
      self.convert(transactions)
    }).disposed(by: disposeBag)
    convert(transactionsLoader.transactions)
    loadRates()
  }
  
  func convert(_ transactions: [TransactionRecord]) {
    self.transactions = transactions.map { tx -> TransactionViewItem in
      let rate = rateConverter.getCoinPrice(code: self.coin.code)
      let fiat = rateConverter.getCoinsPrice(code: self.coin.code, amount: tx.amount)
//      App.instance.ratesManager.getHistoricalRate(coinCode: self.coin.code, date: tx.date).observeOn(MainScheduler.instance).subscribe(onSuccess: { (rate) in
//        print(rate)
//      }).disposed(by: disposeBag)
      return TransactionViewItem.from(tx, self.coin, self.adapter.receiveAddress, fiat, rate)
    }
  }
  
  func loadRates() {
  }
}
