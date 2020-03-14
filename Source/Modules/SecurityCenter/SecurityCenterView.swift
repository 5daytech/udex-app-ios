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
          
          SettingsItemToggleView(icon: "passcode", title: "Passcode enabled", isToggleOn: $viewModel.isTogglePinEnabled)
          .padding([.leading], -16)
          .padding([.trailing], -16)
            .onAppear {
              self.viewModel.syncToggles()
            }
          
          NavigationLink(destination: PinView(title: "Enter old passcode", viewModel: PinViewModel(true, onSuccess: nil))) {
            SettingsItemView(icon: "edit_passcode", title: "Edit passcode")
            .padding([.leading], -16)
            .padding([.trailing], -30)
          }
          .disabled(viewModel.isEditDisabled)
          
          SettingsItemToggleView(icon: "fingerprint", title: "Biometric", isToggleOn: $viewModel.isFaceToggleEnabled)
          .padding([.leading], -16)
          .padding([.trailing], -16)
          .disabled(viewModel.isEditDisabled)
        }
        NavigationLink("", destination: PinView(title: "Enter new passcode", viewModel: PinViewModel(onSuccess: nil), onSuccess: {
          self.viewModel.enablePasscode()
        }), isActive: $viewModel.showPinPage)
        NavigationLink("", destination: PinView(title: "Enter passcode", viewModel: PinViewModel(onSuccess: nil), onValidate: {
          self.viewModel.disablePasscode()
        }), isActive: $viewModel.showPinPageForDisable)
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
