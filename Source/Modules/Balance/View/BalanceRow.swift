import SwiftUI

struct BalanceRow: View {
  var balance: Balance
  var expanded: Bool
  
    var body: some View {
      VStack {
        HStack {
          Image("ethereum")
          VStack {
            HStack {
              Text("wETH")
              Spacer()
              Text(balance.balance) +
              Text("WETH")
            }
            HStack {
              Text("$168.17 per wETH")
              Spacer()
              Text("$66.86")
            }
          }
        }
        if expanded {
          HStack {
            Spacer()
            Button(action: {
              
            }) {
              VStack {
                Image("ethereum")
                Text("Send")
              }
            }
            Spacer()
            Button(action: {
              
            }) {
              VStack {
                Image("ethereum")
                Text("Send")
              }
            }
            
            Spacer()
            Button(action: {
              
            }) {
              VStack {
                Image("ethereum")
                Text("Send")
              }
            }
            Spacer()
            Button(action: {
              
            }) {
              VStack {
                Image("ethereum")
                Text("Send")
              }
            }
            Spacer()
          }
        }
      }
      .cornerRadius(5)
    }
}

//struct BalanceRow_Previews: PreviewProvider {
//    static var previews: some View {
//      BalanceRow(balance: <#Balance#>, expanded: true)
//      .previewLayout(.fixed(width: 300, height: 100))
//    }
//}
