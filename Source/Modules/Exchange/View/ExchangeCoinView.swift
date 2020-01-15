import SwiftUI

struct ExchangeCoinView: View {
  
  var item: ExchangeCoinViewItem?
  
  var body: some View {
    HStack {
      Image(item?.code ?? "WETH")
      .renderingMode(.original)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 25, height: 25)
      
      VStack(alignment: .leading) {
        Text(item?.code ?? "None")
        Text("Balance")
        .font(.system(size: 14))
        .foregroundColor(Color("T2"))
        Text(item?.balanceStr ?? "0.00")
        .font(.system(size: 14))
        .foregroundColor(Color("T2"))
      }
    }
  }
}

struct ExchangeCoinView_Previews: PreviewProvider {
  static var previews: some View {
    ExchangeCoinView(item: ExchangeCoinViewItem(code: "ZRX", balance: 50_000.0))
  }
}
