import Foundation

extension Decimal {
  func toDisplayFormat(_ precise: Int = 4) -> String {
    return NumberUtils.instance.format(self, precise: precise)
  }
}
