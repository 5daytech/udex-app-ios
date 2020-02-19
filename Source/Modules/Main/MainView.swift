import SwiftUI

struct MainView: View {
  
  @State var showWrapCard = false
  @State var showUnwrapCard = false
  let screenHeight = UIScreen.main.bounds.height
  
  @ObservedObject var viewModel = MainViewModel(
    wordsManager: App.instance.wordsManager,
    authManager: App.instance.authManager,
    cleanupManager: App.instance.cleanupManager
  )
  
  var body: some View {
    VStack {
      if viewModel.isLoggedIn {
        ZStack {
          TabView {
            //          NavigationView {
            //
            //          }
            //          .navigationBarTitle(Text("Balance"))
            BalanceView(onWrap: {
              self.showWrapCard = true
            }, onUnwrap: {
              self.showUnwrapCard = true
            }, onSend: {
              
            }, onReceive: {
              
            })
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
          
          // WRAP CARD
          BottomCard(
            showBottomCard: $showWrapCard,
            content: ConvertView(
              viewModel: ConvertViewModel(
                config: ConvertConfig(
                  coinCode: "ETH",
                  type: .WRAP),
                onDone: {
                  self.showWrapCard = false
                }
              )
            )
          )
          .offset(y: screenHeight - ( showWrapCard ? (screenHeight - 100) : 0))
          .animation(.easeInOut(duration: 0.3))
          
          // UNWRAP CARD
          BottomCard(
            showBottomCard: $showUnwrapCard,
            content: ConvertView(
              viewModel: ConvertViewModel(
                config: ConvertConfig(
                  coinCode: "WETH",
                  type: .UNWRAP),
                onDone: {
                  self.showUnwrapCard = false
                }
              )
            )
          )
          .offset(y: screenHeight - ( showUnwrapCard ? (screenHeight - 100) : 0))
          .animation(.easeInOut(duration: 0.3))
        }
      } else {
        GuestView(restoreViewModel: viewModel.restoreViewModel!, onCreateWallet: {
          self.viewModel.createWallet()
        })
      }
    }
  }
}
