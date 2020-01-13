import SwiftUI

struct MainView: View {
  
  @ObservedObject var viewModel: MainViewModel
  
  var body: some View {
    VStack {
      if viewModel.isWordsSaved {
        TabView {
          NavigationView {
            BalanceView(
              viewModel: BalanceViewModel(
                adapterManager: App.instance.adapterManager,
                coins: App.instance.appConfigProvider.coins
              )
            )
            .navigationBarTitle(Text("Balance"))
            .navigationBarItems(leading: Button(action: {
              self.viewModel.logout()
            }){
              Text("Logout")
            })
          }
          .tabItem({
            Text("Balance")
          })
          OrdersList(
            viewModel: OrdersViewModel(
              relayerAdapter: App.instance.relayerAdapterManager.mainRelayer
            )
          )
          
          ExchangeView(viewModel: ExchangeViewModel())
          .tabItem {
            Text("Exchange")
          }
        }
      } else {
        InputWordsView { (words) in
          self.viewModel.inputWords(words: words)
        }
      }
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(viewModel: MainViewModel())
  }
}
