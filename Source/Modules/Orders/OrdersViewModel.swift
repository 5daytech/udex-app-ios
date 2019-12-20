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
  
  private let numberFormatter: NumberFormatter
  
  init(relayerManager: IRelayerManager) {
    self.relayerManager = relayerManager
    
    numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 4
  }
  
  func loadOrders() {
    let base = relayerManager.availableRelayers[0].availablePairs[0].first.assetData
    let quote = relayerManager.availableRelayers[0].availablePairs[0].second.assetData
    relayerManager.getOrderbook(relayerId: 0, base: base, qoute: quote)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { (response) in
        self.sellOrders = response.asks.records.map { self.convert(signedOrder: $0.order) }
        self.buyOrders = response.bids.records.map { self.convert(signedOrder: $0.order) }
      }, onError: { (error) in
        Logger.e("OnError", error: error)
      }).disposed(by: disposeBag)
  }
  
  private func convert(signedOrder: SignedOrder) -> Order {
    let maker = Double(signedOrder.makerAssetAmount)! * pow(Double(10), Double(-18))
    let taker = Double(signedOrder.takerAssetAmount)! * pow(Double(10), Double(-18))
    
    return Order(
      maker: numberFormatter.string(from: NSNumber(value: maker))!,
      taker: numberFormatter.string(from: NSNumber(value: taker))!
    )
  }
}
