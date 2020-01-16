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
  
  private init(words: [String]? = nil) {
    appConfigProvider = AppConfigProvider(words: words)
    
    let ethereumKitManager = EthereumKitManager(appConfigProvider: appConfigProvider)
    
    let ethereumKit = try! ethereumKitManager.ethereumKit(words: appConfigProvider.defaultWords())
    
    
    let words = appConfigProvider.defaultWords()
    
    let adapterFactory: IAdapterFactory = AdapterFactory(appConfigProvider: appConfigProvider, ethereumKitManager: ethereumKitManager)
    
    ratesConverter = RatesConverter()
    ratesManager = RatesManager()
    coinManager = CoinManager(appConfigProvider: appConfigProvider)

    adapterManager = AdapterManager(coinManager: coinManager, adapterFactory: adapterFactory, ethereumKitManager: ethereumKitManager, words: words)
    
    zrxKitManager = ZrxKitManager(appConfigProvider: appConfigProvider)
    
    relayerAdapterManager = RelayerAdapterManager(
      zrxkit: zrxKitManager.zrxkit,
      ethereumKit: ethereumKit,
      coinManager: coinManager,
      appConfiguration: appConfigProvider
    )
  }
  
  static func reinit(words: [String]) {
    instance = App(words: words)
  }
}
