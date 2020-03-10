import SwiftUI

struct CoinManagerRow: View {
  @Binding var isEnabled: Bool
  var coin: Coin
  
  var body: some View {
    HStack {
      if isEnabled {
        Image("enabled")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 10, height: 10)
          .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text(coin.title)
          .font(.system(size: 14))
          .foregroundColor(Color("T1"))
        Text(coin.code)
          .font(.system(size: 14, weight: .bold))
        .foregroundColor(Color("T2"))
      }
      .padding(.leading, isEnabled ? 0 : 35)
      
      Spacer()
      Image(coin.code)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 25, height: 25)
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: isEnabled ? 45 : 8))
    }
    .background(Color("other_coin_background"))
    .padding(EdgeInsets(top: 0, leading: isEnabled ? -37 : 0, bottom: 0, trailing: isEnabled ? -37 : 0))
  }
}
