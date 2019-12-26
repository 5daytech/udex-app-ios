import zrxkit
import HSHDWalletKit
import BigInt

class ZrxKitManager: IZrxKitManager {
  
  let zrxkit: ZrxKit
  let zrxExchange: IZrxExchange
  
  static func getContractGasProvider() -> ContractGasProvider {
    class ContractGasProviderImpl: ContractGasProvider {
      func getGasPrice(_ contractFunc: String) -> BigUInt {
        return 5_000_000_000
      }
      
      func getGasPrice() -> BigUInt {
        getGasPrice("")
      }
      
      func getGasLimit(_ contractFunc: String) -> BigUInt {
        switch contractFunc {
        case "deposit":
          return 100_000
        case "withdraw":
          return 100_000
        case "approve":
          return 80_000
        default:
          return 500_000
        }
      }
      
      func getGasLimit() -> BigUInt {
        getGasLimit("")
      }
    }
    
    return ContractGasProviderImpl()
  }
  
  init(appConfigProvider: IAppConfigProvider) {
    let seed = Mnemonic.seed(mnemonic: appConfigProvider.defaultWords())
    let coinType: UInt32 = appConfigProvider.zrxNetwork == .MainNet ? 60 : 1
    let hdWallet = HDWallet(seed: seed, coinType: coinType, xPrivKey: 0, xPubKey: 0)
    let privateKey = try! hdWallet.privateKey(account: 0, index: 0, chain: .external).raw
    
    zrxkit = ZrxKit.getInstance(relayers: appConfigProvider.relayers, privateKey: privateKey, infuraKey: appConfigProvider.infuraCredentials.secret, networkType: appConfigProvider.zrxNetwork, gasInfoProvider: ZrxKitManager.getContractGasProvider())
    zrxExchange = zrxkit.getExchangeInstance()
  }
}
