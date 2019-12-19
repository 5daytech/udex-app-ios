//
//  CoinType.swift
//  UDEX
//
//  Created by Abai Abakirov on 12/19/19.
//  Copyright © 2019 MakeUseOf. All rights reserved.
//

import Foundation
import BigInt

enum CoinType {
  case Ethereum
  case Erc20(address: String, decimal: Int, fee: BigUInt = BigUInt.zero)
}
