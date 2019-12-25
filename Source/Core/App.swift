import RxSwift
import zrxkit
import HSHDWalletKit

class App {
  static let instance = App()
  
  let appConfigProvider: IAppConfigProvider
  let adapterManager: IAdapterManager
  
  let disposeBag = DisposeBag()
  let zrxkit: ZrxKit
  let zrxExchange: IZrxExchange
  let zrxNetwork = ZrxKit.NetworkType.Ropsten
  
  let exchangePairs: [Pair<AssetItem, AssetItem>] = [
    getExchangePair(from: "ZRX",  to: "WETH"),
    getExchangePair(from: "WBTC", to: "WETH"),
    getExchangePair(from: "DAI",  to: "WETH"),
    getExchangePair(from: "USDT", to: "WETH"),
    getExchangePair(from: "HT",   to: "WETH"),
    getExchangePair(from: "LINK", to: "WETH"),
    getExchangePair(from: "ZRX",  to: "WBTC"),
    getExchangePair(from: "DAI",  to: "WBTC"),
    getExchangePair(from: "USDT", to: "WBTC"),
    getExchangePair(from: "HT",   to: "WBTC"),
    getExchangePair(from: "LINK", to: "WBTC"),
    getExchangePair(from: "LINK", to: "USDT")
  ]
  
  private init() {
    appConfigProvider = AppConfigProvider()
    
    let ethereumKitManager = EthereumKitManager(appConfigProvider: appConfigProvider)
    
    let words = appConfigProvider.defaultWords()
    
    let seed = Mnemonic.seed(mnemonic: words)
    let hdWallet = HDWallet(seed: seed, coinType: 1, xPrivKey: 0, xPubKey: 0)
    let privateKey = try! hdWallet.privateKey(account: 0, index: 0, chain: .external).raw
    
    
    let adapterFactory: IAdapterFactory = AdapterFactory(appConfigProvider: appConfigProvider, ethereumKitManager: ethereumKitManager)

    adapterManager = AdapterManager(adapterFactory: adapterFactory, ethereumKitManager: ethereumKitManager, coins: appConfigProvider.coins, words: words)

    let relayerConfig = RelayerConfig(baseUrl: "https://relayer.ropsten.fridayte.ch", suffix: "", version: "v2")

    let relayers = [
      Relayer(
        id: 0,
        name: "Ropsten Friday Tech",
        availablePairs: App.instance.exchangePairs,
        feeRecipients: ["0xA5004C8b2D64AD08A80d33Ad000820d63aa2cCC9".lowercased()],
        exchangeAddress: zrxNetwork.exchangeAddress,
        config: relayerConfig
      )
    ]

    let infuraProjectSecret: String = try! Configuration.value(for: "INFURA_PROJECT_SECRET")
    zrxkit = ZrxKit.getInstance(relayers: relayers, privateKey: privateKey, infuraKey: infuraProjectSecret)
    zrxExchange = zrxkit.getExchangeInstance()
  }
  
  static private func getExchangePair(from: String, to: String) -> Pair<AssetItem, AssetItem> {
    return Pair<AssetItem, AssetItem>(
      first: ZrxKit.assetItemForAddress(address: addressFromSymbol(symbol: from)),
      second: ZrxKit.assetItemForAddress(address: addressFromSymbol(symbol: to))
    )
  }
  
  static private func addressFromSymbol(symbol: String) -> String {
    let coin = App.instance.appConfigProvider.coins.filter { $0.code == symbol }.first
    if let coin = coin {
      switch coin.type {
      case .erc20(let address, _, _, _, _):
        return address
      default:
        return ""
      }
    }
    return ""
  }
}
