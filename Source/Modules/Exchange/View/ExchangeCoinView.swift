import SwiftUI

struct ExchangeCoinView: View {
  
  var item: ExchangeCoinViewItem?
  
  var body: some View {
    HStack {
      Image(item?.coin.code ?? "WETH")
      .renderingMode(.original)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 25, height: 25)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(item?.coin.code ?? "None")
          .font(.custom(Constants.Fonts.regular, size: 12))
        Text("Balance")
          .font(.custom(Constants.Fonts.regular, size: 10))
          .foregroundColor(Color("T2"))
        Text(item?.balance.toDisplayFormat() ?? "0.00")
        .font(.custom(Constants.Fonts.regular, size: 10)  )
        .foregroundColor(Color("T2"))
      }
      
      Spacer()
      
      if item != nil && item!.state != .none {
        Image(item!.state == .down ? "arrow_down" : "arrow_up")
      }
    }
  }
}
