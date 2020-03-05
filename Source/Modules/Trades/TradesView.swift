import SwiftUI

struct TradesView: View {
  
  var ordersViewModel: OrdersViewModel
  @State var isOrders = true
  
  var body: some View {
    VStack {
      HStack {
        Spacer()
        Button(action: {
          self.isOrders = true
        }) {
          VStack {
            Text("OPEN ORDERS")
            .foregroundColor(isOrders ? Color("main") : Color("T2"))
            .font(.system(size: 14, weight: .bold))
            
            Rectangle()
              .frame(width: 110, height: 1)
            .foregroundColor(isOrders ? Color("main") : Color("T2"))
          }
        }
        Spacer()
        Image("sep_dots")
          .resizable()
          .frame(width: 4, height: 24)
        Spacer()
        Button(action: {
          self.isOrders = false
        }) {
          VStack {
            Text("TRADE HISTORY")
              .foregroundColor(isOrders ? Color("T2") : Color("main"))
              .font(.system(size: 14, weight: .bold))
            
            Rectangle()
              .frame(width: 110, height: 1)
            .foregroundColor(isOrders ? Color("T2") : Color("main"))
          }
        }
        Spacer()
      }
      
      if isOrders {
        OrdersView(viewModel: ordersViewModel)
      } else {
        ExchangeHistoryView()
      }
    }
  }
}
