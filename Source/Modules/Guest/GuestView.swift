import SwiftUI

struct GuestView: View {
  
  var restoreViewModel: RestoreViewModel
  var onCreateWallet: () -> Void
  
  var body: some View {
    NavigationView {
      VStack {
        Spacer()
        Button(action: {
          self.onCreateWallet()
        }) {
          Spacer()
          Text("CREATE WALLET")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Color("background"))
            .padding([.top, .bottom], 16)
          Spacer()
        }
        .background(Color("main"))
        
        
        NavigationLink(destination: RestoreWalletView(viewModel: restoreViewModel)) {
          Text("RESTORE")
          .foregroundColor(Color("T1"))
            .padding([.top, .bottom], 16)
        }
      }
    }
    .accentColor(Color("main"))
  }
}
