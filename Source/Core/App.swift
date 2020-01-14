import RxSwift
import zrxkit
import HSHDWalletKit

class App {
  static var instance = App()
  
  let appConfigProvider: IAppConfigProvider
  let adapterManager: IAdapterManager
  let coinManager: ICoinManager
  let zrxKitManager: IZrxKitManager
  let relayerAdapterManager: IRelayerAdapterManager
  
  private init(words: [String]? = nil) {
    appConfigProvider = AppConfigProvider(words: words)
    
    let ethereumKitManager = EthereumKitManager(appConfigProvider: appConfigProvider)
    
    let words = appConfigProvider.defaultWords()
    
    let adapterFactory: IAdapterFactory = AdapterFactory(appConfigProvider: appConfigProvider, ethereumKitManager: ethereumKitManager)

    adapterManager = AdapterManager(adapterFactory: adapterFactory, ethereumKitManager: ethereumKitManager, coins: appConfigProvider.coins, words: words)
    
    zrxKitManager = ZrxKitManager(appConfigProvider: appConfigProvider)
    
    coinManager = CoinManager(appConfigProvider: appConfigProvider)
    
    relayerAdapterManager = RelayerAdapterManager(
      zrxkit: zrxKitManager.zrxkit,
      ethereumKit: ethereumKitManager.ethereumKit!,
      coinManager: coinManager,
      appConfiguration: appConfigProvider
    )
  }
  
  static func reinit(words: [String]) {
    instance = App(words: words)
  }
}
