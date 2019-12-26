//
//  OrdersList.swift
//  UDEX
//
//  Created by Abai Abakirov on 12/18/19.
//  Copyright © 2019 MakeUseOf. All rights reserved.
//

import SwiftUI

struct OrdersList: View {
  @ObservedObject var viewModel: OrdersViewModel
  
  var body: some View {
    VStack {
      HStack {
        Text("Current Pair")
        Spacer()
        Text(viewModel.currentPair.first.address)
        Spacer()
        Text(viewModel.currentPair.second.address)
      }
      HStack(alignment: .center, spacing: 0) {
        List(viewModel.buyOrders) { order in
          OrderRow(order: order)
        }
        List(viewModel.sellOrders) { order in
          OrderRow(order: order)
        }
      }
      .onAppear {
        self.viewModel.loadOrders()
      }
    }
  }
}
