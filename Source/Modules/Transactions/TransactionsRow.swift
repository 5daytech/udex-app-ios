import SwiftUI

struct TransactionsRow: View {
  
  var item: TransactionViewItem
  
  var body: some View {
    HStack {
      Image(item.incoming ? "income" : "outcome")
        .renderingMode(.template).foregroundColor(item.incoming ? Color("green") : Color("red"))
      VStack(alignment: .leading) {
        Text(item.getDay())
          .foregroundColor(Color("T2"))
        Text(item.getTime())
      }
      Spacer()
      VStack(alignment: .trailing) {
        Text("\(item.incoming ? "+" : "-") \(item.coinValue.toDisplayFormat()) \(item.coin.code)")
          .font(.system(size: 16, weight: .bold))
          .foregroundColor(item.incoming ? Color("green") : Color("red"))
        Text("$\(item.fiatValue.toDisplayFormat(2))")
          .foregroundColor(Color("T2"))
      }
    }
  }
}
