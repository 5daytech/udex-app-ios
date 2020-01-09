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
  
  var address: String {
    switch self {
    case .erc20(let address, _, _, _, _):
      return address
    default:
      return ""
    }
  }
}

extension CoinType: Equatable {
  public static func ==(lhs: CoinType, rhs: CoinType) -> Bool {
    switch (lhs, rhs) {
    case (.ethereum, .ethereum): return true
    case (.erc20(let lhsAddress, let lhsFee, let lhsGasLimit, _, _), .erc20(let rhsAddress, let rhsFee, let rhsGasLimit, _, _)):
      return lhsAddress == rhsAddress && lhsFee == rhsFee && lhsGasLimit == rhsGasLimit
    default: return false
    }
  }
}
