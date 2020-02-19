import Foundation
import BigInt

extension BigUInt {
  func toNormalDecimal(decimal: Int) -> Decimal {
    "\(self)".movePointToLeft(decimal: decimal)
  }
}
