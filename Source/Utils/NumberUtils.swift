import Foundation

class NumberUtils {
  static let instance = NumberUtils()
  
  private let numberFormatter: NumberFormatter
  
  private init() {
    numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 4
  }
  
  func format(_ number: Decimal) -> String {
    return numberFormatter.string(from: NSNumber(value: (number as NSDecimalNumber).doubleValue))!
  }
}
