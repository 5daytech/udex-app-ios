//
//  App.swift
//  UDEX
//
//  Created by Abai Abakirov on 12/18/19.
//  Copyright © 2019 MakeUseOf. All rights reserved.
//

import RxSwift
import zrxkit
import HSHDWalletKit

class App {
  static let instance = App()
  
  let disposeBag = DisposeBag()
  let zrxkit: ZrxKit
  let zrxExchange: IZrxExchange
  let zrxNetwork = ZrxKit.NetworkType.Ropsten
  
  static let coins: [Coin] = [
    Coin(
      title: "Ethereum",
      code: "ETH",
      coinType: .Ethereum
    ),
    Coin(
      title: "Wrapped ETH",
      code: "WETH",
      coinType: .Erc20(
        address: "0xc778417e063141139fce010982780140aa0cd5ab",
        decimal: 18
      )
    ),
    Coin(
      title: "0x",
      code: "ZRX",
      coinType: .Erc20(
        address: "0xff67881f8d12f372d91baae9752eb3631ff0ed00",
        decimal: 18
      )
    ),
    Coin(
      title: "Wrapped Bitcoin",
      code: "WBTC",
      coinType: .Erc20(
        address: "0x96639968b1da3438dbb618465bcb2bf7b25ee6ad",
        decimal: 18
      )
    ),
    Coin(
      title: "Dai",
      code: "DAI",
      coinType: .Erc20(
        address: "0xd914796ec26edd3f9651393f9751e0f3c00dd027",
        decimal: 18
      )
    ), // It's CHO
    Coin(
      title: "ChainLink",
      code: "LINK",
      coinType: .Erc20(
        address: "0x30845a385581ce1dc51d651ff74689d7f4415146",
        decimal: 18
      )
    ), // It's TMKV2
    Coin(
      title: "Tether USD",
      code: "USDT",
      coinType: .Erc20(
        address: "0x6D00364318D008C3AEA08c097c25F5639AB5D2e6",
        decimal: 3
      )
    ), // It's PPA
    Coin(
      title: "Huobi",
      code: "HT",
      coinType: .Erc20(
        address: "0x52E64BB7aEE0E5bdd3a1995E3b070e012277c0fd",
        decimal: 2
      )
    ) // It's TMK
  ]
  
  static let exchangePairs: [Pair<AssetItem, AssetItem>] = [
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
    let relayerConfig = RelayerConfig(baseUrl: "https://relayer.ropsten.fridayte.ch", suffix: "", version: "v2")
    
    let relayers = [
      Relayer(
        id: 0,
        name: "Ropsten Friday Tech",
        availablePairs: App.exchangePairs,
        feeRecipients: ["0xA5004C8b2D64AD08A80d33Ad000820d63aa2cCC9".lowercased()],
        exchangeAddress: zrxNetwork.exchangeAddress,
        config: relayerConfig
      )
    ]
    
    let words = "burden crumble violin flip multiply above usual dinner eight unusual clay identify".split(separator: " ").map { String($0) }
    let seed = Mnemonic.seed(mnemonic: words)
    let hdWallet = HDWallet(seed: seed, coinType: 1, xPrivKey: 0, xPubKey: 0)
    let privateKey = try! hdWallet.privateKey(account: 0, index: 0, chain: .external).raw
    
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
    let coin = coins.filter { $0.code == symbol }.first
    if let coin = coin {
      switch coin.coinType {
      case .Erc20(let address, _, _):
        return address
      default:
        return ""
      }
    }
    return ""
  }
}
