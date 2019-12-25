import SwiftUI

struct BalanceView: View {
  @ObservedObject var viewModel: BalanceViewModel
  
    var body: some View {
      List(viewModel.balances) { balance in
        Button(action: {
        
        }) {
          BalanceRow(balance: balance, expanded: false)
        }
      }
    }
}
