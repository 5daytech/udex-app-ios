import SwiftUI

struct TransactionsView: View {
  @ObservedObject var viewModel: TransactionsViewModel
  let screenHeight = UIScreen.main.bounds.height
  @State var isDetailedInfo = false
  @State var item: TransactionViewItem!
  
  var body: some View {
    ZStack {
      List(viewModel.transactions) { transaction in
        Button(action: {
          withAnimation {
            self.item = transaction
            self.isDetailedInfo = true
          }
        }) {
          TransactionsRow(item: transaction)
        }
      }
      .disabled(isDetailedInfo)
      .blur(radius: isDetailedInfo ? 3 : 0)
      
      if isDetailedInfo {
        BottomCard(showBottomCard: $isDetailedInfo, showNumberPad: false, content: TransactionDetails(item: self.item))
        .offset(y: screenHeight - ( isDetailedInfo ?
          screenHeight - 400 : 0))
        .animation(.easeInOut(duration: 0.3))
      }
    }
    .navigationBarTitle(Text("Transactions"))
  }
}
