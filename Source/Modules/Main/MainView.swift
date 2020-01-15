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
          .tabItem {
            Image("balance").renderingMode(.template)
          }
          
          OrdersBookView(
            viewModel: viewModel.ordersViewModel
          )
          .tabItem {
            Image("markets").renderingMode(.template)
          }
          
          ExchangeView(viewModel: ExchangeViewModel())
          .tabItem {
            Image("exchange").renderingMode(.template)
          }
          
          OrdersView(viewModel: viewModel.ordersViewModel)
          .tabItem {
            Image("orders").renderingMode(.template)
          }
        }
        .accentColor(Color("main"))
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
