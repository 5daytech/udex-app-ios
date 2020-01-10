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
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
