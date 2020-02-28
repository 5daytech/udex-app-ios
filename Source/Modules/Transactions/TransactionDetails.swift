import SwiftUI

struct TransactionDetails: View {
  
  var item: TransactionViewItem
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(item.coin.title).foregroundColor(Color("main"))
      +
      Text("Transaction")
      HStack {
        Spacer()
        VStack(alignment: .center) {
          Text("\(item.incoming ? "+" : "-") \(item.coinValue.toDisplayFormat()) \(item.coin.code)")
            .foregroundColor(item.incoming ? Color("green") : Color("red"))
          Text("$\(item.fiatValue.toDisplayFormat(2))")
        }
        Spacer()
      }
      HStack {
        Text("Rate Received:")
        Spacer()
        Text("\(item.historicalRate?.toDisplayFormat() ?? "0.0") per \(item.coin.code)")
      }
      HStack {
        Text("Time:")
        Spacer()
        Text(item.getFull())
      }
      HStack {
        Text("Status:")
        Spacer()
        Text(item.status.description)
      }
      HStack {
        Text("From")
        Spacer()
        Text("#\(item.from ?? "")")
        .lineLimit(1)
        .frame(width: 200)
      }
      Button(action: {
        UIApplication.shared.open(URL(string: "https://ropsten.etherscan.io/tx/\(self.item.transactionHash)")!)
      }) {
        Spacer()
        Text("FULL INFO")
          .font(.system(size: 14, weight: .bold))
          .padding([.top, .bottom], 10)
        Spacer()
      }
      .background(Color("main"))
      .foregroundColor(Color("background"))
    }
  }
}

extension TransactionDetails: NumberPadInputable {
  func inputNumber(_ number: String) {
    
  }
}
