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
          NavigationView {
            BalanceView(
              viewModel: BalanceViewModel()
            )
            .navigationBarTitle(Text("Balance"))
          }
          .tabItem {
            Image("balance").renderingMode(.template)
          }
          
          NavigationView {
            ExchangeView(viewModel: ExchangeViewModel(isMarketOrder: false))
            .navigationBarTitle("Limit order")
          }
          .tabItem {
            Image("exchange").renderingMode(.template)
          }
          
          NavigationView {
            ExchangeView(viewModel: ExchangeViewModel(isMarketOrder: true))
            .navigationBarTitle("Swap")
          }
          .tabItem {
            Image("swap").renderingMode(.template)
          }
          
          OrdersView(viewModel: viewModel.ordersViewModel!)
          .tabItem {
            Image("orders").renderingMode(.template)
          }
          
          SettingsView()
          .tabItem {
            Image("settings").renderingMode(.template)
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
