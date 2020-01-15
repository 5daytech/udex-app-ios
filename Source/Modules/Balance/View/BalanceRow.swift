import SwiftUI

struct BalanceRow: View {
  var balance: BalanceViewItem
  var expanded: Bool
  
    var body: some View {
      VStack {
        HStack {
          Image(balance.code)
          .renderingMode(.original)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 25, height: 25)
          
          VStack (spacing: 8) {
            HStack {
              Text(balance.title)
                .foregroundColor(Color("T1"))
              Spacer()
              Text(balance.balance)
              .foregroundColor(Color("T1"))
              Text(balance.code)
                .foregroundColor(Color("T1"))
            }
            HStack {
              Text("$168.17 per \(balance.code)")
                .font(.system(size: 10))
                .foregroundColor(Color("T2"))
              Spacer()
              Text("$66.86")
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
                Image("ETH")
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
                Image("ETH")
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
          }
        }
      }
      .background(Color("secondary_background"))
      .cornerRadius(10)
      .clipped()
      .shadow(radius: 3)
    }
}
