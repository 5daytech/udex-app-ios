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
  let ratesManager: IRatesManager
  let ratesConverter: RatesConverter
  let wordsManager: IWordsManager
  var authManager: IAuthManager
  let cleanupManager: ICleanupManager
  
  private init(words: [String]? = nil) {
    appConfigProvider = AppConfigProvider(words: words)
    
    let ethereumKitManager = EthereumKitManager(appConfigProvider: appConfigProvider)
    
    coinManager = CoinManager(appConfigProvider: appConfigProvider)
    
    let securedStorage = SecuredStorage()
    authManager = AuthManager(securedStorage: securedStorage, coinManager: coinManager)
    wordsManager = WordsManager()
    
    let adapterFactory: IAdapterFactory = AdapterFactory(appConfigProvider: appConfigProvider, ethereumKitManager: ethereumKitManager)
    
    ratesManager = RatesManager(coinManager: coinManager)
    ratesConverter = RatesConverter(ratesManager: ratesManager)

    adapterManager = AdapterManager(coinManager: coinManager, adapterFactory: adapterFactory, ethereumKitManager: ethereumKitManager, authManager: authManager)
    authManager.adapterManager = adapterManager
    
    zrxKitManager = ZrxKitManager(appConfigProvider: appConfigProvider, authManager: authManager)
    
    relayerAdapterManager = RelayerAdapterManager(
      zrxKitManager: zrxKitManager,
      ethereumKitManager: ethereumKitManager,
      coinManager: coinManager,
      ratesConverter: ratesConverter,
      appConfiguration: appConfigProvider,
      authManager: authManager
    )
    authManager.relayerAdapterManager = relayerAdapterManager
    
    cleanupManager = CleanupManager(authManager: authManager, zrxKitManager: zrxKitManager)
  }
}
