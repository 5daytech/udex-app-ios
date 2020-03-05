import SwiftUI

struct ExchangeHistoryRow: View {
  
  var tx: ExchangeRecord
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Text(tx.hash)
          .font(.system(size: 12))
        .lineLimit(1)
          .padding(8)
      }
      .onTapGesture {
        UIApplication.shared.open(URL(string: "https://ropsten.etherscan.io/tx/\(self.tx.hash)")!)
      }
      .border(Color("T2"), width: 1)
      HStack {
        Spacer()
        Text(DateHelper.instance.full(tx.date))
          .font(.system(size: 12))
        .foregroundColor(Color("T2"))
      }
      ForEach(tx.fromCoins) { coin in
        HStack {
          Image(coin.coinCode)
            .resizable()
            .frame(width: 20, height: 20)
          Text("\(coin.isIncome ? "+" : "-") \(coin.transactionRecord.amount.toString())")
            .foregroundColor(coin.isIncome ? Color("green") : Color("red"))
        }
      }
      ForEach(tx.toCoins) { coin in
        HStack {
          Image(coin.coinCode)
          Text("\(coin.isIncome ? "+" : "-") \(coin.transactionRecord.amount.toString())")
          .foregroundColor(coin.isIncome ? Color("green") : Color("red"))
        }
      }
    }
  }
}
  
