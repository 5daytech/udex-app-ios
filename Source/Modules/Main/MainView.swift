import SwiftUI

struct MainView: View {
    var body: some View {
      TabView {
        NavigationView {
          BalanceView(
            viewModel: BalanceViewModel(
              adapterManager: App.instance.adapterManager,
              coins: App.instance.appConfigProvider.coins
            )
          )
          .navigationBarTitle(Text("Balance"))
        }
        .tabItem({
          Text("Balance")
        })
        NavigationView {
          OrdersList(
            viewModel: OrdersViewModel(
              relayerAdapter: App.instance.relayerAdapterManager.mainRelayer
            )
          )
          .navigationBarTitle(Text("Order book"))
        }
        .tabItem({
          Text("Order book")
        })
        NavigationView {
          ExchangeView(viewModel: ExchangeViewModel())
          .navigationBarTitle(Text("Exchange"))
        }
        .tabItem {
          Text("Exchange")
        }
      }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
