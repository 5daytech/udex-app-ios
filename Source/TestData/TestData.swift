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
    let order1 = Order(maker: 10.0, taker: 20.0)
    let order2 = Order(maker: 123.0, taker: 20.0)
    let order3 = Order(maker: 423.0, taker: 890.0)
    let order4 = Order(maker: 40.0, taker: 20.0)
    let order5 = Order(maker: 10.0, taker: 90.0)
    return [order1, order2, order3, order4, order5]
  }
}
