import SwiftUI

struct SecurityCenterView: View {
  
  @ObservedObject var viewModel = App.instance.securityCenterViewModel
  
  var body: some View {
      VStack {
        List {
          NavigationLink(destination: ShowKeyView()) {
            SettingsItemView(
              icon: "backup",
              title: "Wallet Backup"
            )
            .padding([.leading], -16)
            .padding([.trailing], -30)
          }
          
          SettingsItemView(
            icon: "trash",
            title: "Remove Wallet",
            titleColor: Color("remove")
          )
          .padding([.leading], -16)
          .padding([.trailing], -30)
            .onTapGesture {
              self.viewModel.logout()
          }
          
        }
      }
    .navigationBarTitle(Text("Security Center"))
  }
}

struct SecurityCenterView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SecurityCenterView()
      SecurityCenterView()
        .environment(\.colorScheme, .dark)
    }
  }
}
