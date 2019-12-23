import SwiftUI

struct BalanceView: View {
  @State private var expandedRow = -1
  
    var body: some View {
      List {
        ForEach((0...20), id: \.self) { index in
          Button(action: {
            self.expandedRow = index
          }) {
            BalanceRow(expanded: index == self.expandedRow)
          }
        }
      }
    }
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceView()
    }
}
