import SwiftUI

struct MainView: View {
    var body: some View {
      TabView {
        NavigationView {
          BalanceView()
          .navigationBarTitle(Text("Balance"))
        }
        .tabItem({
          Text("Balance")
        })
        NavigationView {
          OrdersList(viewModel: OrdersViewModel(relayerManager: App.instance.zrxkit.relayerManager))
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
