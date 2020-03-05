import Foundation

struct ExchangeRecord {
  let hash: String
  let date: Date
  let fromCoins: [ExchangeRecordItem]
  let toCoins: [ExchangeRecordItem]
}

struct ExchangeRecordItem {
  let coinCode: String
  let transactionRecord: TransactionRecord
}
