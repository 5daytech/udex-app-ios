import Foundation

struct ExchangeCoinViewItem: Identifiable {
  var id = UUID().uuidString
  
  let code: String
  let balance: Decimal
  
  var balanceStr: String {
    let numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 4
    return numberFormatter.string(from: balance as NSDecimalNumber)!
  }
}
