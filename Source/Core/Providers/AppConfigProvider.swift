import Foundation
import zrxkit

class AppConfigProvider: IAppConfigProvider {  
  let ipfsId = "QmXTJZBMMRmBbPun6HFt3tmb3tfYF2usLPxFoacL7G5uMX"
  let ipfsGateways = [
    "https://ipfs-ext.horizontalsystems.xyz",
    "https://ipfs.io"
  ]
  
  let companyWebPageLink = "https://horizontalsystems.io"
  let appWebPageLink = "https://unstoppable.money"
  let reportEmail = "hsdao@protonmail.ch"
  let reportTelegramGroup = "unstoppable_wallet"
  
  let reachabilityHost = "ipfs.horizontalsystems.xyz"
  
  let words: [String]?
  
  init(words: [String]? = nil) {
    self.words = words
  }
  
  var zrxNetwork: ZrxKit.NetworkType {
    testMode ? ZrxKit.NetworkType.Ropsten : ZrxKit.NetworkType.MainNet
  }
  
  var testMode: Bool {
    try! Configuration.value(for: "TEST_MODE") == "true"
  }
  
  func defaultWords() -> [String] {
    if words != nil {
      return words!
    }
    
    do {
      let wordsString: String = try Configuration.value(for: "DEFAULT_WORDS")
      return wordsString.split(separator: " ", omittingEmptySubsequences: true).map(String.init)
    } catch {
      return []
    }
  }
  
  var infuraCredentials: (id: String, secret: String) {
    let id: String = try! Configuration.value(for: "INFURA_PROJECT_ID")
    let secret: String = try! Configuration.value(for: "INFURA_PROJECT_SECRET")
    return (id: id, secret: secret)
  }
  
  var etherscanKey: String {
    try! Configuration.value(for: "ETHERESCAN_KEY")
  }
  
  private func getExchangePair(from: String, to: String) -> Pair<AssetItem, AssetItem> {
    return Pair<AssetItem, AssetItem>(
      first: ZrxKit.assetItemForAddress(address: addressFromSymbol(symbol: from)),
      second: ZrxKit.assetItemForAddress(address: addressFromSymbol(symbol: to))
    )
  }
  
  private func addressFromSymbol(symbol: String) -> String {
    let coin = coins.filter { $0.code == symbol }.first
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
  
  var exchangePairs: [Pair<AssetItem, AssetItem>] {
    if testMode {
      return [
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
    } else {
      return [
        getExchangePair(from: "USDC", to: "DAI"),
        getExchangePair(from: "USDC", to: "WETH"),
        getExchangePair(from: "ZRX", to: "WETH"),
        getExchangePair(from: "BAT", to: "WETH"),
        getExchangePair(from: "LPT", to: "WETH"),
        getExchangePair(from: "LINK", to: "WETH"),
        getExchangePair(from: "FOAM", to: "WETH"),
        getExchangePair(from: "MKR", to: "WETH"),
        getExchangePair(from: "OMG", to: "WETH"),
        getExchangePair(from: "DAI", to: "WETH"),
        getExchangePair(from: "USDT", to: "WETH")
      ]
    }
  }
  
  let currencies: [Currency] = [
    Currency(code: "USD", symbol: "\u{0024}", decimal: 2),
    Currency(code: "EUR", symbol: "\u{20AC}", decimal: 2),
    Currency(code: "GBP", symbol: "\u{00A3}", decimal: 2),
    Currency(code: "JPY", symbol: "\u{00A5}", decimal: 2)
  ]
  
  var featuredCoins: [Coin] {
    [
      coins[0],
      coins[1],
      coins[2]
    ]
  }
  
  private let debugCoins = [
    Coin(
      title: "Ethereum",
      code: "ETH",
      decimal: 18,
      type: .ethereum
    ),
    Coin(
      title: "Wrapped ETH",
      code: "WETH",
      decimal: 18,
      type: .erc20(
        address: "0xc778417e063141139fce010982780140aa0cd5ab"
      )
    ),
    Coin(
      title: "0x",
      code: "ZRX",
      decimal: 18,
      type: .erc20(
        address: "0xff67881f8d12f372d91baae9752eb3631ff0ed00"
      )
    ),
    Coin(
      title: "Wrapped Bitcoin",
      code: "WBTC",
      decimal: 18,
      type: .erc20(
        address: "0x96639968b1da3438dbb618465bcb2bf7b25ee6ad"
      )
    ),
    Coin(
      title: "Dai",
      code: "DAI",
      decimal: 18,
      type: .erc20(
        address: "0xd914796ec26edd3f9651393f9751e0f3c00dd027"
      )
    ), // It's CHO
    Coin(
      title: "ChainLink",
      code: "LINK",
      decimal: 18,
      type: .erc20(
        address: "0x30845a385581ce1dc51d651ff74689d7f4415146"
      )
    ), // It's TMKV2
    Coin(
      title: "Tether USD",
      code: "USDT",
      decimal: 3,
      type: .erc20(
        address: "0x6D00364318D008C3AEA08c097c25F5639AB5D2e6"
      )
    ), // It's PPA
    Coin(
      title: "Huobi",
      code: "HT",
      decimal: 2,
      type: .erc20(
        address: "0x52E64BB7aEE0E5bdd3a1995E3b070e012277c0fd"
      )
    ) // It's TMK
  ]
  private let releaseCoins = [
    Coin(title: "Ethereum", code: "ETH", decimal: 18, type: .ethereum),
    Coin(title: "Wrapped ETH", code: "WETH", decimal: 18, type: .erc20(address: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2")),
    Coin(title: "0x", code: "ZRX", decimal: 18, type: .erc20(address: "0xE41d2489571d322189246DaFA5ebDe1F4699F498")),
    Coin(title: "USD Coin", code: "USDC", decimal: 6, type: .erc20(address: "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48")),
    Coin(title: "Dai", code: "DAI", decimal: 18, type: .erc20(address: "0x6b175474e89094c44da98b954eedeac495271d0f")),
    Coin(title: "Sai", code: "SAI", decimal: 18, type: .erc20(address: "0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359")),
    Coin(title: "Tether USD", code: "USDT", decimal: 6, type: .erc20(address: "0xdAC17F958D2ee523a2206206994597C13D831ec7")),
    Coin(title: "Chain Link", code: "LINK", decimal: 18, type: .erc20(address: "0x514910771af9ca656af840dff83e8264ecf986ca")),
    Coin(title: "OmiseGO", code: "OMG", decimal: 18, type: .erc20(address: "0xd26114cd6EE289AccF82350c8d8487fedB8A0C07")),
    Coin(title: "Maker", code: "MKR", decimal: 18, type: .erc20(address: "0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2")),
    Coin(title: "FOAM Token", code: "FOAM", decimal: 18, type: .erc20(address: "0x4946fcea7c692606e8908002e55a582af44ac121")),
    Coin(title: "Livepeer Token", code: "LPT", decimal: 18, type: .erc20(address: "0x58b6a8a3302369daec383334672404ee733ab239")),
    Coin(title: "Basic Attention Token", code: "BAT", decimal: 18, type: .erc20(address: "0x0D8775F648430679A709E98d2b0Cb6250d2887EF"))
  ]
  
  var coins: [Coin] {
    if testMode {
      return debugCoins
    } else {
      return releaseCoins
    }
  }
  
  var relayers: [Relayer] {
    if testMode {
     return [
        Relayer(
          id: 0,
          name: "Ropsten Friday Tech",
          availablePairs: exchangePairs,
          feeRecipients: ["0xA5004C8b2D64AD08A80d33Ad000820d63aa2cCC9".lowercased()],
          exchangeAddress: zrxNetwork.exchangeAddress,
          config: RelayerConfig(
            baseUrl: "https://ropsten.api.udex.app/sra",
            suffix: "",
            version: "v3")
        )
      ]
    } else {
      return [
        Relayer(
          id: 0,
          name: "RadarRelay",
          availablePairs: exchangePairs,
          feeRecipients: ["0xa258b39954cef5cb142fd567a46cddb31a670124".lowercased()],
          exchangeAddress: zrxNetwork.exchangeAddress,
          config: RelayerConfig(
            baseUrl: "https://api.radarrelay.com/",
            suffix: "0x/",
            version: "v3")
        )
      ]
    }
  }
}
