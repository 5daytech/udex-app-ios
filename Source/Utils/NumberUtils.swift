import Foundation

class NumberUtils {
  static let instance = NumberUtils()
  
  private let numberFormatter: NumberFormatter
  
  private init() {
    numberFormatter = NumberFormatter()
  }
  
  func format(_ number: Decimal, precise: Int = 4) -> String {
    numberFormatter.maximumFractionDigits = precise
    return numberFormatter.string(from: number as NSDecimalNumber)!
  }
}
