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
  let exchangeHistoryManager: IExchangeHistoryManager
  
  let securityCenterViewModel: SecurityCenterViewModel
  
  // MARK: Providers
  let appConfigProvider: IAppConfigProvider
  let feeRateProvider: IFeeRateProvider
  let processingDurationProvider: IProcessingDurationProvider
  
  // MARK: Storage
  let enabledCoinsStorage: IEnabledCoinsStorage
  
  let pinManager: IPinManager
  let lockManager: ILockManager
  
  let biometricManager: IBiometricManager
  
  var lastExitDate: TimeInterval = 0
  
  
  private init(words: [String]? = nil) {
    appConfigProvider = AppConfigProvider(words: words)
    enabledCoinsStorage = EnabledCoinsDao()
    feeRateProvider = FeeRateProvider()
    processingDurationProvider = ProcessingDurationProvider()
    
    let ethereumKitManager = EthereumKitManager(appConfigProvider: appConfigProvider)
    
    coinManager = CoinManager(appConfigProvider: appConfigProvider, enabledCoinsStorage: enabledCoinsStorage)
    
    let securedStorage = SecuredStorage()
    authManager = AuthManager(securedStorage: securedStorage, coinManager: coinManager)
    wordsManager = WordsManager()
    
    let adapterFactory: IAdapterFactory = AdapterFactory(ethereumKitManager: ethereumKitManager, feeRateProvider: feeRateProvider)
    
    ratesManager = RatesManager(coinManager: coinManager)
    ratesConverter = RatesConverter(ratesManager: ratesManager)

    adapterManager = AdapterManager(coinManager: coinManager, adapterFactory: adapterFactory, ethereumKitManager: ethereumKitManager, authManager: authManager)
    authManager.adapterManager = adapterManager
    
    exchangeHistoryManager = ExchangeHistoryManager(adapterManager)
    
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
    
    pinManager = PinManager(securedStorage: securedStorage)
    lockManager = LockManager(pinManager: pinManager)
    
    biometricManager = BiometricManager()
    
    securityCenterViewModel = SecurityCenterViewModel(cleanupManager: cleanupManager, pinManager: pinManager)
  }
}
