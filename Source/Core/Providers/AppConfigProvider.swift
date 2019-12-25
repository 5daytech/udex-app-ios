import Foundation

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
  
  var testMode: Bool {
    try! Configuration.value(for: "TEST_MODE") == "true"
  }
  
  func defaultWords() -> [String] {
    do {
      let wordsString: String = try Configuration.value(for: "DEFAULT_WORDS")
      return wordsString.split(separator: " ", omittingEmptySubsequences: true).map(String.init)
    } catch {
      return []
    }
  }
  
  var infuraCredentials: (id: String, secret: String?) {
    let id: String = try! Configuration.value(for: "INFURA_PROJECT_ID")
    let secret: String = try! Configuration.value(for: "INFURA_PROJECT_SECRET")
    return (id: id, secret: secret)
  }
  
  var etherscanKey: String {
    try! Configuration.value(for: "ETHERESCAN_KEY")
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
      coins[2],
      coins[3],
      coins[4],
      coins[5],
    ]
  }
  
  let coins = [
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
}
