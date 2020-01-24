import RxSwift
import EthereumKit
import Erc20Kit
import HSHDWalletKit

class EthereumKitManager: IEthereumKitManager {  
  let disposeBag = DisposeBag()
  
  private let appConfigProvider: IAppConfigProvider
  private var kit: EthereumKit.Kit?
  
  init(appConfigProvider: IAppConfigProvider) {
    self.appConfigProvider = appConfigProvider
  }
  
  func ethereumKit(authData: AuthData) throws -> EthereumKit.Kit {
    if let ethereumKit = self.kit {
      return ethereumKit
    }
    
    kit = try EthereumKit.Kit.instance(
      privateKey: authData.privateKey,
      syncMode: .api,
      networkType: appConfigProvider.testMode ? .ropsten : .mainNet,
      infuraCredentials: appConfigProvider.infuraCredentials,
      etherscanApiKey: appConfigProvider.etherscanKey,
      walletId: authData.walletId
    )
    
    kit?.start()
    return kit!
  }
  
  var statusInfo: [(String, Any)]? {
    kit?.statusInfo()
  }
  
  func refresh() {
    kit?.refresh()
  }
  
  func unlink() {
    kit?.stop()
    kit = nil
  }
}
