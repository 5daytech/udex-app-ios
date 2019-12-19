//
//  OrderList.swift
//  UDEX
//
//  Created by Abai Abakirov on 12/18/19.
//  Copyright © 2019 MakeUseOf. All rights reserved.
//

import SwiftUI

struct Order: Identifiable {
  var id = UUID().uuidString
  
  let makerAmount: String
  let takerAmount: String
  
  init(maker: String, taker: String) {
    makerAmount = maker
    takerAmount = taker
  }
}
