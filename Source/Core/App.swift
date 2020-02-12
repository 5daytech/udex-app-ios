import RxSwift
import zrxkit
import HSHDWalletKit

class App {
  static var instance = App()
  
  // MARK: Managers
  let adapterManager: IAdapterManager
  let coinManager: ICoinManager
  let zrxKitManager: IZrxKitManager
  let relayerAdapterManager: IRelayerAdapterManager
  let ratesManager: IRatesManager
  let ratesConverter: RatesConverter
  let wordsManager: IWordsManager
  var authManager: IAuthManager
  let cleanupManager: ICleanupManager
  
  let securityCenterViewModel: SecurityCenterViewModel
  
  // MARK: Providers
  let appConfigProvider: IAppConfigProvider
  let feeRateProvider: IFeeRateProvider
  let processingDurationProvider: IProcessingDurationProvider
  
  
  private init(words: [String]? = nil) {
    appConfigProvider = AppConfigProvider(words: words)
    feeRateProvider = FeeRateProvider()
    processingDurationProvider = ProcessingDurationProvider()
    
    let ethereumKitManager = EthereumKitManager(appConfigProvider: appConfigProvider)
    
    coinManager = CoinManager(appConfigProvider: appConfigProvider)
    
    let securedStorage = SecuredStorage()
    authManager = AuthManager(securedStorage: securedStorage, coinManager: coinManager)
    wordsManager = WordsManager()
    
    let adapterFactory: IAdapterFactory = AdapterFactory(ethereumKitManager: ethereumKitManager, feeRateProvider: feeRateProvider)
    
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
    
    securityCenterViewModel = SecurityCenterViewModel(cleanupManager: cleanupManager)
  }
}
