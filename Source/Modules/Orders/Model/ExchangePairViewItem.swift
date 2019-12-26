import Foundation

struct ExchangePairViewItem: Identifiable {
  var id = UUID().uuidString
  
  let baseCoin: String
  let basePrice: Double
  let quoteCoin: String
  let quotePrice: Double
}
