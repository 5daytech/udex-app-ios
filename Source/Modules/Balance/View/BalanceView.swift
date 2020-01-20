import SwiftUI

struct BalanceView: View {
  @ObservedObject var viewModel: BalanceViewModel
  
  @State public var showRefreshView: Bool = false
  @State public var pullStatus: CGFloat = 0
  
  var body: some View {
    
//    RefreshableList(showRefreshView: $showRefreshView, pullStatus: $pullStatus, action: {
//      self.viewModel.refresh()
//    }) {
//      ForEach(self.viewModel.balances, id: \.self) { balance in
//        BalanceRow(balance: balance, expanded: false)
//      }
//    }
    
    List {
      ForEach(self.viewModel.balances, id: \.self) { balance in
        BalanceRow(balance: balance, expanded: false)
      }
    }
  }
}
