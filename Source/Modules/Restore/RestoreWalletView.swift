import SwiftUI

struct RestoreWalletView: View {
  
  var viewModel: RestoreViewModel
  
  @State var mnemonicKey: String = ""
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Enter Secret Key (separated by space)").padding()
        .foregroundColor(Color("main"))
        .font(.system(size: 16, weight: .bold))
      MultilineTextField(text: $mnemonicKey)
        .frame(minHeight: 50, maxHeight: 100)
      Button(action: {
        self.viewModel.onRestore(text: self.mnemonicKey)
      }) {
        Spacer()
        Text("RESTORE")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("background"))
          .padding([.top, .bottom], 16)
        Spacer()
      }
      .background(Color("main"))
      Spacer()
    }
    .navigationBarTitle(Text("Restore Wallet"))
  }
}
