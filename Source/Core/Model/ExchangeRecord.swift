import Foundation

struct ExchangeRecord: Identifiable {
  let id = UUID().uuidString
  
  let hash: String
  let date: Date
  let fromCoins: [ExchangeRecordItem]
  let toCoins: [ExchangeRecordItem]
}

struct ExchangeRecordItem: Identifiable {
  let id = UUID().uuidString
  
  let coinCode: String
  let transactionRecord: TransactionRecord
  
  var isIncome: Bool {
    transactionRecord.type == .incoming
  }
}
