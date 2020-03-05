import SwiftUI

struct ExchangeHistoryView: View {
  
  @ObservedObject var viewModel = ExchangeHistoryViewModel()
  
  var body: some View {
    VStack {
      List(viewModel.transactions) { tx in
        VStack {
          ExchangeHistoryRow(tx: tx)
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
          Rectangle()
          .frame(height: 1)
            .background(Color("T2"))
        }
      }
    }
  }
}
