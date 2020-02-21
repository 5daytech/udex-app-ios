import SwiftUI

struct MainView: View {
  
  enum DialogViewsState {
    case NONE
    case CONFIRM_CONVERT
    case PROGRESS
    case TRANSACTION_SENT(String)
    case ERROR(String)
  }
  
  enum BottomViewsState {
    case NONE
    case WRAP
    case UNWRAP
    case SEND
    case RECEIVE
  }
  
  @State var viewState: DialogViewsState = .NONE
  @State var bottomViewState: BottomViewsState = .NONE
  @State var showWrapCard = false
  @State var showUnwrapCard = false
  let screenHeight = UIScreen.main.bounds.height
  @State var convertView: ConvertView?
  
  @ObservedObject var viewModel = MainViewModel(
    wordsManager: App.instance.wordsManager,
    authManager: App.instance.authManager,
    cleanupManager: App.instance.cleanupManager
  )
  
  private func bottomView() -> AnyView? {
    switch bottomViewState {
    case .NONE:
      return nil
    case .WRAP:
      convertView = getConvertView(ConvertConfig(coinCode: "ETH", type: .WRAP))
      return AnyView(
        BottomCard(
          showBottomCard: $showWrapCard,
          content: convertView!
        )
      )
    case .UNWRAP:
      convertView = getConvertView(ConvertConfig(coinCode: "WETH", type: .UNWRAP))
      return AnyView(
        BottomCard(
          showBottomCard: $showWrapCard,
          content: convertView!
        )
      )
    case .SEND:
      return nil
    case .RECEIVE:
      return nil
    }
  }
  
  private func topView() -> AnyView? {
    switch viewState {
    case .CONFIRM_CONVERT:
      return AnyView(
        ConvertConfirmView(onConfirm: {
          self.viewState = .PROGRESS
          self.convertView?.confirmConvert()
          self.convertView = nil
        })
        .transition(.move(edge: .bottom))
      )
    case .PROGRESS:
      return AnyView(
        ProcessingDialog()
        .transition(.move(edge: .bottom))
      )
    case .TRANSACTION_SENT(let hash):
      return AnyView(
        TransactionSentDialog(hash: hash)
        .transition(.move(edge: .bottom))
      )
    case .ERROR(let message):
      return AnyView(
        ErrorDialog(message: message) {
          withAnimation {
            self.viewState = .NONE
          }
        }
      )
    case .NONE:
      return nil
    }
  }
  
func getConvertView(_ config: ConvertConfig) -> ConvertView {
    let convertView = ConvertView(
      viewModel: ConvertViewModel(
        config: config,
        onDone: {
          self.showWrapCard = false
        },
        onConfirm: {
          self.viewState = .CONFIRM_CONVERT
        },
        onProcessing: {
          self.viewState = .PROGRESS
        },
        onTransaction: { transactionAddress in
          self.viewState = .TRANSACTION_SENT(transactionAddress)
        },
        onError: { message in
          self.viewState = .ERROR(message)
        }
      )
    )
    return convertView
  }
  
  var isBlur: Bool {
    switch viewState {
    case .CONFIRM_CONVERT, .ERROR, .PROGRESS, .TRANSACTION_SENT:
      return true
    case .NONE:
      return false
    }
  }
  
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
          .blur(radius: isBlur ? 3 : 0)
          
          // WRAP CARD

          bottomView()?
          .offset(y: screenHeight - ( showWrapCard ? (screenHeight - 100) : 0))
          .animation(.easeInOut(duration: 0.3))
          
          
          if isBlur {
            Rectangle()
              .foregroundColor(Color.white.opacity(0.01))
              .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
              .onTapGesture {
                withAnimation {
                  self.viewState = .NONE
                }
            }
          
            
          }
          
          topView()
          
          // UNWRAP CARD
//          BottomCard(
//            showBottomCard: $showUnwrapCard,
//            content: ConvertView(
//              viewModel: ConvertViewModel(
//                config: ConvertConfig(
//                  coinCode: "WETH",
//                  type: .UNWRAP),
//                onDone: {
//                  self.showUnwrapCard = false
//                }
//              )
//            )
//          )
//          .offset(y: screenHeight - ( showUnwrapCard ? (screenHeight - 100) : 0))
//          .animation(.easeInOut(duration: 0.3))
        }
      } else {
        GuestView(restoreViewModel: viewModel.restoreViewModel!, onCreateWallet: {
          self.viewModel.createWallet()
        })
      }
    }
  }
}
