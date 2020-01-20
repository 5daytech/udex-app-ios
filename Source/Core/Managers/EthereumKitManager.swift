import RxSwift
import EthereumKit
import Erc20Kit
import HSHDWalletKit

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
    
    let hdWallet = HDWallet(seed: Mnemonic.seed(mnemonic: words), coinType: 60, xPrivKey: 0, xPubKey: 0)
    let privateKey = try hdWallet.privateKey(account: 0, index: 0, chain: .external).raw
    
    ethereumKit = try EthereumKit.Kit.instance(
      privateKey: privateKey,
      syncMode: .api,
      networkType: appConfigProvider.testMode ? .ropsten : .mainNet,
      infuraCredentials: appConfigProvider.infuraCredentials,
      etherscanApiKey: appConfigProvider.etherscanKey,
      walletId: "default"
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
