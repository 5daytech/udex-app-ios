import SwiftUI

struct SettingsView: View {
  var body: some View {
    NavigationView {
      VStack {
        List {
          NavigationLink(destination: SecurityCenterView()) {
          SettingsItemView(icon: "security", title: "Security center")
            .padding([.leading], -16)
            .padding([.trailing], -30)
          }
        }
      }
      .navigationBarTitle("Settings")
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SettingsView()
      SettingsView()
        .environment(\.colorScheme, .dark)
    }
  }
}
