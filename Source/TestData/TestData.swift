import Foundation

struct TestData {
  static func orders() -> [OrderViewItem] {
    let order1 = OrderViewItem(makerAmount: "10.0", takerAmount: "20.0", isBuy: false)
    let order2 = OrderViewItem(makerAmount: "10.0", takerAmount: "20.0", isBuy: false)
    let order3 = OrderViewItem(makerAmount: "10.0", takerAmount: "20.0", isBuy: false)
    let order4 = OrderViewItem(makerAmount: "10.0", takerAmount: "20.0", isBuy: false)
    let order5 = OrderViewItem(makerAmount: "10.0", takerAmount: "20.0", isBuy: false)
    return [order1, order2, order3, order4, order5]
  }
}
