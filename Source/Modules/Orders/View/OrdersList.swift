import SwiftUI

struct OrdersList: View {
  @ObservedObject var viewModel: OrdersViewModel
  
  let ordersSpacing: CGFloat = 30
  
  var body: some View {
    NavigationView {
      VStack {
        ZStack(alignment: .top) {
          ScrollView {
            HStack(alignment: .bottom, spacing: ordersSpacing) {
              VStack(alignment: .center, spacing: ordersSpacing) {
                ForEach(viewModel.buyOrders) { order in
                  OrderRow(order: order)
                }
              }
              VStack(alignment: .center, spacing: ordersSpacing) {
                ForEach(viewModel.sellOrders) { order in
                  OrderRow(order: order)
                }
              }
            }
          }
          .offset(x: 0, y: 50)
          
          HStack(alignment: .top) {
            Text("Current Pair")
              .offset(x: 0, y: 12)
            Spacer()
            List(viewModel.availablePairs) { pair in
              Button(action: {
                self.viewModel.onChoosePair(pair: pair)
              }) {
                HStack {
                  Text(pair.baseCoin)
                  Spacer()
                  Text(pair.quoteCoin)
                }
              }
            }
            .frame(height: viewModel.isExpanded ? 400 : 40)
          }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
      }
      .navigationBarTitle(Text("Order book"))
    }
  }
  
  
}
