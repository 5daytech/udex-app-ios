import SwiftUI

struct ExchangeHistoryRow: View {
  
  var tx: ExchangeRecord
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Text(tx.hash)
          .font(.custom(Constants.Fonts.bold, size: 12))
        .lineLimit(1)
          .padding(8)
      }
      .onTapGesture {
        App.instance.openTransactionInfo(self.tx.hash)
      }
      .border(Color("T2"), width: 1)
      HStack {
        Spacer()
        Text(DateHelper.instance.full(tx.date))
          .font(.custom(Constants.Fonts.regular, size: 14))
        .foregroundColor(Color("T2"))
      }
      ForEach(tx.fromCoins) { coin in
        HStack {
          Image(coin.coinCode)
            .resizable()
            .frame(width: 20, height: 20)
          Text("\(coin.isIncome ? "+" : "-") \(coin.transactionRecord.amount.toString())")
            .foregroundColor(coin.isIncome ? Color("green") : Color("red"))
            .font(.custom(Constants.Fonts.regular, size: 14))
        }
      }
      ForEach(tx.toCoins) { coin in
        HStack {
          Image(coin.coinCode)
          Text("\(coin.isIncome ? "+" : "-") \(coin.transactionRecord.amount.toString())")
          .foregroundColor(coin.isIncome ? Color("green") : Color("red"))
          .font(.custom(Constants.Fonts.regular, size: 14))
        }
      }
    }
  }
}
  
