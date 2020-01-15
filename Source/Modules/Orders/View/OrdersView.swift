//
//  OrdersView.swift
//  UDEX
//
//  Created by Abai Abakirov on 1/14/20.
//  Copyright © 2020 MakeUseOf. All rights reserved.
//

import SwiftUI

struct OrdersView: View {
  
  @ObservedObject var viewModel: OrdersViewModel
  
  var body: some View {
    NavigationView {
      List(viewModel.myOrders) { order in
        OrderRow(order: order)
      }
      .navigationBarTitle(Text("My Orders"))
    }
  }
}
