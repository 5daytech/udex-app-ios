import Foundation
import SwiftUI

struct TransactionViewItem: Identifiable {
  var id = UUID().uuidString
  
  let coin: Coin
  let transactionHash: String
  let coinValue: Decimal
  let fiatValue: Decimal
  let fee: Decimal?
  let fiatFee: Decimal?
  let historicalRate: Decimal?
  let from: String?
  let to: String?
  let incoming: Bool
  let date: Date?
  let status: TransactionStatus
  let innerIndex: Int
  
  static func from(_ item: TransactionRecord, _ coin: Coin, _ address: String, _ fiat: Decimal, _ rate: Decimal) -> TransactionViewItem {
    TransactionViewItem(
      coin: coin,
      transactionHash: item.transactionHash,
      coinValue: item.amount,
      fiatValue: fiat,
      fee: item.fee,
      fiatFee: 0,
      historicalRate: rate,
      from: item.from,
      to: item.to,
      incoming: item.to == address,
      date: item.date,
      status: TransactionStatus.COMPLETED,
      innerIndex: item.interTransactionIndex
    )
  }
  
  func getDay() -> String {
    DateHelper.instance.day(date ?? Date())
  }
  
  func getTime() -> String {
    DateHelper.instance.time(date ?? Date())
  }
  
  func getFull() -> String {
    DateHelper.instance.full(date ?? Date())
  }
}
