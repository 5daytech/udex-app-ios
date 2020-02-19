import Foundation
import BigInt

extension Decimal {
  func toDisplayFormat(_ precise: Int = 4) -> String {
    return NumberUtils.instance.format(self, precise: precise)
  }
  
  func toEth() -> BigUInt {
    BigUInt("\((self * pow(10, 18)))", radix: 10)!
  }
}
