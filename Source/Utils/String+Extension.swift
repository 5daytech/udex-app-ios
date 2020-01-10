import Foundation

extension String {
  func normalizeToDecimal(decimal: Int) -> Decimal {
    Decimal(Double(self)! * pow(Double(10), Double(decimal)))
  }
}
