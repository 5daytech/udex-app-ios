import SwiftUI

struct ExchangeCoinView: View {
  
  var item: ExchangeCoinViewItem
  
  var body: some View {
    HStack {
      Image("ethereum")
      VStack {
        Text(item.code)
        Text("Balance")
        Text("\(item.balance)")
      }
    }
  }
}

struct ExchangeCoinView_Previews: PreviewProvider {
  static var previews: some View {
    ExchangeCoinView(item: ExchangeCoinViewItem(code: "ZRX", balance: 50_000.0))
  }
}
