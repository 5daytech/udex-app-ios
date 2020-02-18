import SwiftUI

struct BalanceRow: View {
  var balance: CoinBalance
  var expanded: Bool
  
    var body: some View {
      VStack {
        HStack {
          Image(balance.coin.code)
          .renderingMode(.original)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 25, height: 25)
          
          VStack (spacing: 8) {
            HStack {
              Text(balance.coin.title)
                .foregroundColor(Color("T1"))
              Spacer()
              Text(balance.balance.toDisplayFormat())
              .foregroundColor(Color("T1"))
              Text(balance.coin.code)
                .foregroundColor(Color("T1"))
            }
            HStack {
              Text("$\(balance.pricePerToken.toDisplayFormat()) per \(balance.coin.code)")
                .font(.system(size: 10))
                .foregroundColor(Color("T2"))
              Spacer()
              Text("$\(balance.fiatBalance.toDisplayFormat())")
                .font(.system(size: 10))
              .foregroundColor(Color("T2"))
            }
          }
        }
        .padding()
        if expanded {
          HStack {
            Spacer()
            Button(action: {
              
            }) {
              VStack {
                Image("receive")
                Text("Receive")
              }
            }
            Spacer()
            Button(action: {
              
            }) {
              VStack {
                Image("send")
                Text("Send")
              }
            }
            
            Spacer()
            Button(action: {
              
            }) {
              VStack {
                Image("ETH")
                Text("Send")
              }
            }
            Spacer()
            Button(action: {
              
            }) {
              VStack {
                Image("wrap")
                Text("Wrap")
              }
            }
            Spacer()
          }
        }
      }
      .background(Color("secondary_background"))
      .cornerRadius(10)
      .clipped()
      .shadow(radius: 3)
    }
}
