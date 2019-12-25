//
//  Coin.swift
//  UDEX
//
//  Created by Abai Abakirov on 12/19/19.
//  Copyright © 2019 MakeUseOf. All rights reserved.
//

import Foundation

struct Coin {
  let title: String
  let code: String
  let decimal: Int
  let type: CoinType
}

extension Coin: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(code)
  }
}

extension Coin: Equatable {
  public static func ==(lhs: Coin, rhs: Coin) -> Bool {
    lhs.title == rhs.title && lhs.code == rhs.code && lhs.decimal == rhs.decimal && lhs.type == rhs.type
  }
}
