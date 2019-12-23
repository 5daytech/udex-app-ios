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
  case ethereum
  case erc20(address: String, fee: Decimal = 0, gasLimit: Int? = nil, minimumRequiredBalance: Decimal = 0, minimumSpendableAmount: Decimal? = nil)
}
