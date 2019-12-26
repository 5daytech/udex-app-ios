//
//  TestData.swift
//  UDEX
//
//  Created by Abai Abakirov on 12/18/19.
//  Copyright © 2019 MakeUseOf. All rights reserved.
//

import Foundation

struct TestData {
  static func orders() -> [Order] {
    let order1 = Order(makerAmount: "10.0", takerAmount: "20.0", isBuy: false)
    let order2 = Order(makerAmount: "10.0", takerAmount: "20.0", isBuy: false)
    let order3 = Order(makerAmount: "10.0", takerAmount: "20.0", isBuy: false)
    let order4 = Order(makerAmount: "10.0", takerAmount: "20.0", isBuy: false)
    let order5 = Order(makerAmount: "10.0", takerAmount: "20.0", isBuy: false)
    return [order1, order2, order3, order4, order5]
  }
}
