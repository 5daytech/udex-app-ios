import SwiftUI
import UIKit

struct SettingsView: View {
  
  @State var showShareSheet = false
  
  var body: some View {
    NavigationView {
      VStack {
        List {
          NavigationLink(destination: SecurityCenterView()) {
            SettingsItemView(icon: "security", title: "Security center")
              .padding([.leading], -16)
              .padding([.trailing], -30)
          }
          
          NavigationLink(destination: CoinManagerView()) {
            SettingsItemView(icon: "coin_manager", title: "Coin Manager")
              .padding([.leading], -16)
              .padding([.trailing], -30)
          }
          
          NavigationLink(destination: AboutView()) {
            SettingsItemView(icon: "about", title: "About UDEX")
              .padding([.leading], -16)
              .padding([.trailing], -30)
          }
          
          SettingsItemView(icon: "share", title: "Tell Friends")
            .padding([.leading], -16)
            .padding([.trailing], -30)
            .onTapGesture {
              self.showShareSheet = true
            }
          
          SettingsItemView(icon: "telegram", title: "Telegram")
            .padding([.leading], -16)
            .padding([.trailing], -30)
            .onTapGesture {
              let appUrl = URL(string: "tg://resolve?domain=udexapp")!
              let webUrl = URL(string: "https://t.me/udexapp")!
              if UIApplication.shared.canOpenURL(appUrl) {
                UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
              } else {
                UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
              }
            }
          
          SettingsItemView(icon: "telegram_bot", title: "Telegram Bot")
            .padding([.leading], -16)
            .padding([.trailing], -30)
            .onTapGesture {
              let appUrl = URL(string: "tg://resolve?domain=udex_bot")!
              let webUrl = URL(string: "https://t.me/udex_bot")!
              if UIApplication.shared.canOpenURL(appUrl) {
                UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
              } else {
                UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
              }
            }
        }
      }
      .navigationBarTitle(Text("Settings").font(.custom(Constants.Fonts.bold, size: 24)))
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .sheet(isPresented: $showShareSheet) {
      ShareSheet(activityItems: [URL(string: "https://udex.app/share")!])
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
