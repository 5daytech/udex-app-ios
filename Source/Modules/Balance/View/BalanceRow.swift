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
          
          VStack {
            HStack {
              Text(balance.title)
              Spacer()
              Text(balance.balance)
              Text(balance.code)
            }
            HStack {
              Text("$168.17 per \(balance.code)").font(.system(size: 10))
              Spacer()
              Text("$66.86").font(.system(size: 10))
            }
          }
        }
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
      .cornerRadius(5)
    }
}

//struct BalanceRow_Previews: PreviewProvider {
//    static var previews: some View {
//      BalanceRow(balance: <#Balance#>, expanded: true)
//      .previewLayout(.fixed(width: 300, height: 100))
//    }
//}
