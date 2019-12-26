//
//  OrdersViewModel.swift
//  UDEX
//
//  Created by Abai Abakirov on 12/19/19.
//  Copyright © 2019 MakeUseOf. All rights reserved.
//

import Foundation
import zrxkit
import RxSwift
import BigInt

class OrdersViewModel: ObservableObject {
  private let disposeBag = DisposeBag()
  @Published var sellOrders: [Order] = []
  @Published var buyOrders: [Order] = []
  
  let relayerManager: IRelayerManager
  
  @Published var currentPair: Pair<AssetItem, AssetItem>
  
  private let numberFormatter: NumberFormatter
  
  init(relayerManager: IRelayerManager) {
    self.relayerManager = relayerManager
    self.currentPair = relayerManager.availableRelayers[0].availablePairs[0]
    
    numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 4
  }
  
  func loadOrders() {
    let base = currentPair.first.assetData
    let quote = currentPair.second.assetData
    relayerManager.getOrderbook(relayerId: 0, base: base, qoute: quote)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { (response) in
        self.sellOrders = response.asks.records.map { self.convert(signedOrder: $0.order, isBuy: false) }
        self.buyOrders = response.bids.records.map { self.convert(signedOrder: $0.order, isBuy: true) }
      }, onError: { (error) in
        Logger.e("OnError", error: error)
      }).disposed(by: disposeBag)
  }
  
  private func convert(signedOrder: SignedOrder, isBuy: Bool) -> Order {
    let maker = Double(signedOrder.makerAssetAmount)! * pow(Double(10), Double(-18))
    let taker = Double(signedOrder.takerAssetAmount)! * pow(Double(10), Double(-18))
    
    return Order(
      makerAmount: numberFormatter.string(from: NSNumber(value: maker))!,
      takerAmount: numberFormatter.string(from: NSNumber(value: taker))!,
      isBuy: isBuy)
  }
}
