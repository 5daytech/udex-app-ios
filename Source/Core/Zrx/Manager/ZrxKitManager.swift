import zrxkit
import HSHDWalletKit
import BigInt

class ZrxKitManager: IZrxKitManager {  
  private var kit: ZrxKit?
  private let authManager: IAuthManager
  private let appConfiguration: IAppConfigProvider
  
  
  static func getContractGasProvider() -> ContractGasProvider {
    class ContractGasProviderImpl: ContractGasProvider {
      func getGasPrice(_ contractFunc: String) -> BigUInt {
        return 8_000_000_000
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
  
  init(appConfigProvider: IAppConfigProvider, authManager: IAuthManager) {
    self.appConfiguration = appConfigProvider
    self.authManager = authManager
  }
  
  func zrxKit() -> ZrxKit {
    if kit != nil {
      return kit!
    }
    
    kit = ZrxKit.getInstance(
      relayers: appConfiguration.relayers,
      privateKey: authManager.authData!.privateKey,
      infuraKey: appConfiguration.infuraCredentials.secret,
      networkType: appConfiguration.zrxNetwork,
      gasInfoProvider: ZrxKitManager.getContractGasProvider()
    )
    return kit!
  }
  
  func unlink() {
    kit = nil
  }
}
