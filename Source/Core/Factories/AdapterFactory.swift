class AdapterFactory: IAdapterFactory {
  private let ethereumKitManager: EthereumKitManager
  private let feeRateProvider: IFeeRateProvider
  
  init(ethereumKitManager: EthereumKitManager, feeRateProvider: IFeeRateProvider) {
    self.ethereumKitManager = ethereumKitManager
    self.feeRateProvider = feeRateProvider
  }
  
  func adapter(coin: Coin, authData: AuthData) -> IAdapter? {
    switch coin.type {
    case .ethereum:
      if let ethereumKit = try? ethereumKitManager.ethereumKit(authData: authData) {
        return EthereumAdapter(ethereumKit: ethereumKit, feeRateProvider: feeRateProvider)
      }
    case let .erc20(address, fee, gasLimit, minimumRequiredBalance, minimumSpendableAmount):
      if let ethereumKit = try? ethereumKitManager.ethereumKit(authData: authData) {
        return try? Erc20Adapter(ethereumKit: ethereumKit, contractAddress: address, feeRateProvider: feeRateProvider, decimal: coin.decimal, fee: fee, gasLimit: gasLimit, minimumRequiredBalance: minimumRequiredBalance, minimumSpendableAmount: minimumSpendableAmount)
      }
    }
    
    return nil
  }
  
}
