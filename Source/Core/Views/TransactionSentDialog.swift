import SwiftUI

struct TransactionSentDialog: View {
  
  var hash: String = ""
  @State private var showingAlert = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("Transaction Sent")
        .font(.system(size: 18, weight: .bold))
        .foregroundColor(Color("T1"))
        .padding([.leading, .top], 16)
      
      HStack {
        Spacer()
        Text(hash)
          .font(.system(size: 12, weight: .bold))
          .padding(5)
        Spacer()
      }
      .onTapGesture {
        self.showingAlert = true
        UIPasteboard.general.string = self.hash
      }
      .alert(isPresented: $showingAlert) {
        Alert(title: Text("Copied!"), dismissButton: .default(Text("Done")))
      }
      .border(Color.gray, width: 1)
      .padding(16)
      
      Button(action: {
        App.instance.openTransactionInfo(self.hash)
      }) {
        Spacer()
        Text("VIEW ON ETHERSCAN.IO")
          .font(.system(size: 14, weight: .bold))
          .padding([.top, .bottom], 10)
        Spacer()
      }
      .background(Color("main"))
      .foregroundColor(Color("background"))
    }
    .background(Color("secondary_background"))
    .clipped()
    .shadow(radius: 5)
  }
}

struct TransactionSentDialog_Previews: PreviewProvider {
  static var previews: some View {
    TransactionSentDialog(hash: "Hash")
  }
}
