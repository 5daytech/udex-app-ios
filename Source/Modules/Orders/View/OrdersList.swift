import SwiftUI

struct OrdersList: View {
  @ObservedObject var viewModel: OrdersViewModel
  
  var body: some View {
    VStack {
      HStack {
        Text("Current Pair")
        Spacer()
        Text(viewModel.currentPair.baseCoin)
        Spacer()
        Text(viewModel.currentPair.quoteCoin)
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
