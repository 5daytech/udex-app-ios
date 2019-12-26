import SwiftUI

struct OrdersList: View {
  @ObservedObject var viewModel: OrdersViewModel
  
  var body: some View {
    VStack {
      ZStack(alignment: .top) {
        HStack(alignment: .center, spacing: 0) {
          List(viewModel.buyOrders) { order in
            OrderRow(order: order)
          }
          List(viewModel.sellOrders) { order in
            OrderRow(order: order)
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
    }
  }
}
