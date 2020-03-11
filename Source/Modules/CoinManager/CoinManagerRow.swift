import SwiftUI

struct CoinManagerRow: View {
  var viewItem: CoinManagerViewItem
  
  var body: some View {
    HStack {
      if viewItem.isEnabled {
        Image("enabled")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 10, height: 10)
          .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text(viewItem.coin.title)
          .font(.system(size: 14))
          .foregroundColor(Color("T1"))
        Text(viewItem.coin.code)
          .font(.system(size: 14, weight: .bold))
        .foregroundColor(Color("T2"))
      }
      .padding(.leading, viewItem.isEnabled ? 0 : 35)
      
      Spacer()
      Image(viewItem.coin.code)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 25, height: 25)
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: viewItem.isEnabled ? 45 : 8))
    }
    .background(Color("other_coin_background"))
    .padding(EdgeInsets(top: 0, leading: viewItem.isEnabled ? -37 : 0, bottom: 0, trailing: viewItem.isEnabled ? -37 : 0))
  }
}
