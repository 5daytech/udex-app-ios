import SwiftUI

struct OrdersView: View {
  
  @ObservedObject var viewModel: OrdersViewModel
  
  var body: some View {
    VStack {
      if viewModel.myOrders.isEmpty {
        Spacer()
        EmptyView(text: "NO OPEN ORDERS")
        Spacer()
      } else {
        List(viewModel.myOrders) { order in
          OrderRow(order: order)
        }
        Button(action: {
          self.viewModel.cancelOrders()
        }) {
          Image("cancel")
          Text("Cancel All Orders")
            .font(.custom(Constants.Fonts.bold, size: 14))
        }
      .accentColor(Color("cancel_color"))
      }
    }
  }
}
