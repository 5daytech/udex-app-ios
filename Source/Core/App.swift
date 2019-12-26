import RxSwift
import zrxkit
import HSHDWalletKit

class App {
  static let instance = App()
  
  let appConfigProvider: IAppConfigProvider
  let adapterManager: IAdapterManager
  
  let disposeBag = DisposeBag()
  let zrxKitManager: ZrxKitManager
  
  private init() {
    appConfigProvider = AppConfigProvider()
    
    let ethereumKitManager = EthereumKitManager(appConfigProvider: appConfigProvider)
    
    let words = appConfigProvider.defaultWords()
    
    let adapterFactory: IAdapterFactory = AdapterFactory(appConfigProvider: appConfigProvider, ethereumKitManager: ethereumKitManager)

    adapterManager = AdapterManager(adapterFactory: adapterFactory, ethereumKitManager: ethereumKitManager, coins: appConfigProvider.coins, words: words)
    
    zrxKitManager = ZrxKitManager(appConfigProvider: appConfigProvider)
  }
}
