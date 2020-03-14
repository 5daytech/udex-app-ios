import SwiftUI

struct MainView: View {
  
  enum DialogViewsState {
    case NONE
    case CONFIRM_CONVERT(ConvertConfirmConfig)
    case CONFIRM_SEND(SendConfirmConfig)
    case PROGRESS
    case TRANSACTION_SENT(String)
    case ERROR(String)
  }
  
  enum BottomViewsState {
    case NONE
    case WRAP
    case UNWRAP
    case SEND(Coin)
    case RECEIVE(Coin)
  }
  
  @State var viewState: DialogViewsState = .NONE
  @State var bottomViewState: BottomViewsState = .NONE
  @State var showBottomCard = false
  let screenHeight = UIScreen.main.bounds.height
  
  @ObservedObject var viewModel = MainViewModel(
    wordsManager: App.instance.wordsManager,
    authManager: App.instance.authManager,
    cleanupManager: App.instance.cleanupManager,
    lockManager: App.instance.lockManager
  )
  
  private func bottomView() -> AnyView? {
    switch bottomViewState {
    case .NONE:
      return nil
    case .WRAP:
      let convertView = getConvertView(ConvertConfig(coinCode: "ETH", type: .WRAP))
      return AnyView(
        BottomCard(
          showBottomCard: $showBottomCard,
          showNumberPad: true,
          content: convertView
        )
      )
    case .UNWRAP:
      let convertView = getConvertView(ConvertConfig(coinCode: "WETH", type: .UNWRAP))
      return AnyView(
        BottomCard(
          showBottomCard: $showBottomCard,
          showNumberPad: true,
          content: convertView
        )
      )
    case .SEND(let coin):
      return AnyView(
        BottomCard(
          showBottomCard: $showBottomCard,
          showNumberPad: true,
          content: SendView(viewModel: SendViewModel(coin: coin, onConfirm: { config in
            self.viewState = .CONFIRM_SEND(config)
          }))
        )
      )
    case .RECEIVE(let coin):
      return AnyView(
        BottomCard(
          showBottomCard: $showBottomCard,
          showNumberPad: false,
          content: ReceiveView(viewModel: ReceiveViewModel(coin: coin)))
      )
    }
  }
  
  private func topView() -> AnyView? {
    switch viewState {
    case .CONFIRM_CONVERT(let config):
      return AnyView(
        ConvertConfirmView(config: config, onConfirm: {
          self.viewState = .PROGRESS
          self.viewModel.convert(config, onTransaction: { (txHash) in
            self.viewState = .TRANSACTION_SENT(txHash)
          }, onError: { error in
            self.viewState = .ERROR(error)
          })
        })
          .transition(.move(edge: .bottom))
      )
    case .CONFIRM_SEND(let config):
      return AnyView(
        SendConfirmView(config: config) {
          self.viewState = .PROGRESS
          self.viewModel.send(config, onTransaction: { (txHash) in
            self.viewState = .TRANSACTION_SENT(txHash)
          }, onError: { error in
            self.viewState = .ERROR(error)
          })
        }
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
          self.showBottomCard = false
      },
        onConfirm: { config in
          self.viewState = .CONFIRM_CONVERT(config)
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
    case .CONFIRM_CONVERT, .CONFIRM_SEND, .ERROR, .PROGRESS, .TRANSACTION_SENT:
      return true
    case .NONE:
      return false
    }
  }
  
  var body: some View {
    VStack {
      if viewModel.isLoggedIn {
        if viewModel.isPinEnabled {
          PinView(viewModel: PinViewModel(onSuccess: {
            self.viewModel.onValidate()
          }), onValidate: {
            self.viewModel.onValidate()
          })
        } else {
          ZStack {
            TabView {
              BalanceView(onWrap: {
                self.showBottomCard = true
                self.bottomViewState = .WRAP
              }, onUnwrap: {
                self.showBottomCard = true
                self.bottomViewState = .UNWRAP
              }, onSend: { coin in
                self.showBottomCard = true
                self.bottomViewState = .SEND(coin)
              }, onReceive: { coin in
                self.showBottomCard = true
                self.bottomViewState = .RECEIVE(coin)
              })
              .tabItem {
                Image("balance").renderingMode(.template)
                Text("")
              }
              
              NavigationView {
                ExchangeView<LimitInteractor>.makeView()
                  .navigationBarTitle("Limit order")
              }
              .navigationViewStyle(StackNavigationViewStyle())
              .tabItem {
                Image("exchange").renderingMode(.template)
                Text("")
              }
              
              NavigationView {
                ExchangeView<MarketInteractor>.makeView()
                  .navigationBarTitle("Swap")
              }
              .navigationViewStyle(StackNavigationViewStyle())
              .tabItem {
                Image("swap").renderingMode(.template)
                Text("")
              }
              
                TradesView(ordersViewModel: viewModel.ordersViewModel!)
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
            
            bottomView()?
              .blur(radius: isBlur ? 3 : 0)
              .offset(y: screenHeight - ( showBottomCard ? self.viewModel.height(for: bottomViewState) : 0))
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
          }
        }
        
      } else {
        GuestView(restoreViewModel: viewModel.restoreViewModel!, onCreateWallet: {
          self.viewModel.createWallet()
        })
      }
    }
  }
}
