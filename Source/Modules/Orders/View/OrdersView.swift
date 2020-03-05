import SwiftUI

struct OrdersView: View {
  
  @ObservedObject var viewModel: OrdersViewModel
  
  var body: some View {
    List(viewModel.myOrders) { order in
      OrderRow(order: order)
    }
  }
}
