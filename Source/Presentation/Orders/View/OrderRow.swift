//
//  OrderView.swift
//  UDEX
//
//  Created by Abai Abakirov on 12/18/19.
//  Copyright © 2019 MakeUseOf. All rights reserved.
//

import SwiftUI

struct OrderRow: View {
  let order: Order
  
  var body: some View {
    HStack(alignment: .top, spacing: 10) {
      Text(order.makerAmount)
      Spacer()
      Text(order.takerAmount)
    }
  }
}

struct OrderRow_Previews: PreviewProvider {
    static var previews: some View {
      OrderRow(order: TestData.orders()[0])
    }
}
