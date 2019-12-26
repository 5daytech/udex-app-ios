import SwiftUI

struct MainView: View {
    var body: some View {
      TabView {
        NavigationView {
          BalanceView(viewModel: BalanceViewModel(adapterManager: App.instance.adapterManager, coins: App.instance.appConfigProvider.coins))
          .navigationBarTitle(Text("Balance"))
        }
        .tabItem({
          Text("Balance")
        })
        NavigationView {
          OrdersList(viewModel: OrdersViewModel(
            relayerManager: App.instance.zrxKitManager.zrxkit.relayerManager,
            relayerAdapter: App.instance.relayerAdapterManager.mainRelayer))
          .navigationBarTitle(Text("Order book"))
        }
        .tabItem({
          Text("Order book")
        })
      }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
