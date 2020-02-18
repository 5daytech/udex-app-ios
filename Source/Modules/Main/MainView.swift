import SwiftUI

struct MainView: View {
  
  @ObservedObject var viewModel = MainViewModel(
    wordsManager: App.instance.wordsManager,
    authManager: App.instance.authManager,
    cleanupManager: App.instance.cleanupManager
  )
  
  var body: some View {
    VStack {
      if viewModel.isLoggedIn {
        TabView {
//          NavigationView {
//
//          }
//          .navigationBarTitle(Text("Balance"))
          BalanceView()
          .tabItem {
            Image("balance").renderingMode(.template)
            Text("")
          }
          
          NavigationView {
            ExchangeView<LimitInteractor>.makeView()
            .navigationBarTitle("Limit order")
          }
          .tabItem {
            Image("exchange").renderingMode(.template)
            Text("")
          }
          
          NavigationView {
            ExchangeView<MarketInteractor>.makeView()
            .navigationBarTitle("Swap")
          }
          .tabItem {
            Image("swap").renderingMode(.template)
            Text("")
          }
          
          OrdersView(viewModel: viewModel.ordersViewModel!)
          .tabItem {
            Image("orders").renderingMode(.template)
            Text("")
          }
          
          SettingsView()
          .tabItem {
            Image("settings").renderingMode(.template)
            Text("")
          }
        }
        .accentColor(Color("main"))
      } else {
        GuestView(restoreViewModel: viewModel.restoreViewModel!, onCreateWallet: {
          self.viewModel.createWallet()
        })
      }
    }
  }
}
