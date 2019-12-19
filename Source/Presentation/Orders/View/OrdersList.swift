//
//  OrdersList.swift
//  UDEX
//
//  Created by Abai Abakirov on 12/18/19.
//  Copyright © 2019 MakeUseOf. All rights reserved.
//

import SwiftUI

struct OrdersList: View {
  let orders: [Order]
  
  var body: some View {
    Text("dasdas")
  }
}

struct OrdersList_Previews: PreviewProvider {
  static var previews: some View {
    OrdersList(orders: TestData.orders())
  }
}
