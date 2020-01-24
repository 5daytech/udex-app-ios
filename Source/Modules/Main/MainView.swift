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
            .navigationBarItems(leading: Button(action: {
              self.viewModel.logout()
            }){
              Text("Logout")
            })
          }
          .tabItem {
            Image("balance").renderingMode(.template)
          }
          
          OrdersBookView(
            viewModel: viewModel.ordersViewModel!
          )
          .tabItem {
            Image("markets").renderingMode(.template)
          }
          
          ExchangeView(viewModel: ExchangeViewModel())
          .tabItem {
            Image("exchange").renderingMode(.template)
          }
          
          OrdersView(viewModel: viewModel.ordersViewModel!)
          .tabItem {
            Image("orders").renderingMode(.template)
          }
        }
        .accentColor(Color("main"))
      } else {
//        InputWordsView { (words) in
//          self.viewModel.inputWords(words: words)
//        }
        GuestView(restoreViewModel: viewModel.restoreViewModel!, onCreateWallet: {
          self.viewModel.createWallet()
        })
      }
    }
  }
}
