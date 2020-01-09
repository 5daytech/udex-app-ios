import RxSwift
import zrxkit
import HSHDWalletKit

class App {
  static let instance = App()
  
  let appConfigProvider: IAppConfigProvider
  let adapterManager: IAdapterManager
  let coinManager: ICoinManager
  let zrxKitManager: IZrxKitManager
  let relayerAdapterManager: IRelayerAdapterManager
  
  private init() {
    appConfigProvider = AppConfigProvider()
    
    let ethereumKitManager = EthereumKitManager(appConfigProvider: appConfigProvider)
    
    let words = appConfigProvider.defaultWords()
    
    let adapterFactory: IAdapterFactory = AdapterFactory(appConfigProvider: appConfigProvider, ethereumKitManager: ethereumKitManager)

    adapterManager = AdapterManager(adapterFactory: adapterFactory, ethereumKitManager: ethereumKitManager, coins: appConfigProvider.coins, words: words)
    
    zrxKitManager = ZrxKitManager(appConfigProvider: appConfigProvider)
    
    coinManager = CoinManager(appConfigProvider: appConfigProvider)
    
    relayerAdapterManager = RelayerAdapterManager(
      zrxkit: zrxKitManager.zrxkit,
      ethereumKit: ethereumKitManager.ethereumKit!,
      coinManager: coinManager
    )
  }
}
