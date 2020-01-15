import Foundation

extension Decimal {
  func toDisplayFormat() -> String {
    return NumberUtils.instance.format(self)
  }
}
