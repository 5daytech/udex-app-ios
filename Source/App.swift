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
  
  private init() {
    let relayerConfig = RelayerConfig(baseUrl: "https://relayer.ropsten.fridayte.ch", suffix: "", version: "v2")
    
    let pairs = [
      Pair<AssetItem, AssetItem>(
        first: ZrxKit.assetItemForAddress(address: "0xc778417e063141139fce010982780140aa0cd5ab"),
        second: ZrxKit.assetItemForAddress(address: "0xff67881f8d12f372d91baae9752eb3631ff0ed00"))
    ]
    
    let relayers = [
      Relayer(
        id: 0,
        name: "Ropsten Friday Tech",
        availablePairs: pairs,
        feeRecipients: ["0xA5004C8b2D64AD08A80d33Ad000820d63aa2cCC9".lowercased()],
        exchangeAddress: zrxNetwork.exchangeAddress,
        config: relayerConfig)
    ]
    
    let words = "burden crumble violin flip multiply above usual dinner eight unusual clay identify".split(separator: " ").map { String($0) }
    let seed = Mnemonic.seed(mnemonic: words)
    let hdWallet = HDWallet(seed: seed, coinType: 1, xPrivKey: 0, xPubKey: 0)
    let privateKey = try! hdWallet.privateKey(account: 0, index: 0, chain: .external).raw
    
    zrxkit = ZrxKit.getInstance(relayers: relayers, privateKey: privateKey, infuraKey: "")
    
    zrxExchange = zrxkit.getExchangeInstance()
    
    zrxkit.relayerManager.getOrderbook(
      relayerId: 0,
      base: pairs[0].first.assetData,
      qoute: pairs[0].second.assetData
    ).observeOn(MainScheduler.instance)
      .subscribe { (response) in
        print(response)
    }.disposed(by: disposeBag)
  }
}
