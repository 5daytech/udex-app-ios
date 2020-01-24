class AdapterFactory: IAdapterFactory {
    private let appConfigProvider: IAppConfigProvider
    private let ethereumKitManager: EthereumKitManager

    init(appConfigProvider: IAppConfigProvider, ethereumKitManager: EthereumKitManager) {
        self.appConfigProvider = appConfigProvider
        self.ethereumKitManager = ethereumKitManager
    }

  func adapter(coin: Coin, authData: AuthData) -> IAdapter? {
        switch coin.type {
        case .ethereum:
          if let ethereumKit = try? ethereumKitManager.ethereumKit(authData: authData) {
                return EthereumAdapter(ethereumKit: ethereumKit)
            }
        case let .erc20(address, fee, gasLimit, minimumRequiredBalance, minimumSpendableAmount):
            if let ethereumKit = try? ethereumKitManager.ethereumKit(authData: authData) {
                return try? Erc20Adapter(ethereumKit: ethereumKit, contractAddress: address, decimal: coin.decimal, fee: fee, gasLimit: gasLimit, minimumRequiredBalance: minimumRequiredBalance, minimumSpendableAmount: minimumSpendableAmount)
            }
        }

        return nil
    }

}
