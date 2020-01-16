import RxSwift
import EthereumKit
import Erc20Kit

class EthereumKitManager {
  let disposeBag = DisposeBag()
  
  private let appConfigProvider: IAppConfigProvider
  private var ethereumKit: EthereumKit.Kit?
  
  init(appConfigProvider: IAppConfigProvider) {
    self.appConfigProvider = appConfigProvider
  }
  
  func ethereumKit(words: [String]) throws -> EthereumKit.Kit {
    if let ethereumKit = self.ethereumKit {
      return ethereumKit
    }
    
    ethereumKit = try EthereumKit.Kit.instance(
      words: words,
      syncMode: .api,
      networkType: appConfigProvider.testMode ? .ropsten : .mainNet,
      infuraCredentials: appConfigProvider.infuraCredentials,
      etherscanApiKey: appConfigProvider.etherscanKey,
      walletId: "default",
      minLogLevel: .error
    )
    
    ethereumKit?.start()
    return ethereumKit!
  }
  
  var statusInfo: [(String, Any)]? {
    ethereumKit?.statusInfo()
  }
  
  func refresh() {
    ethereumKit?.refresh()
  }
}
