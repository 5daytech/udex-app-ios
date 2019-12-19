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
  @Published private(set) var orders: [Order] = []
  
  let relayerManager: IRelayerManager
  
  init(relayerManager: IRelayerManager) {
    self.relayerManager = relayerManager
  }
  
  func loadOrders() {
    let base = relayerManager.availableRelayers[0].availablePairs[0].first.assetData
    let quote = relayerManager.availableRelayers[0].availablePairs[0].second.assetData
    relayerManager.getOrderbook(relayerId: 0, base: base, qoute: quote)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { (response) in
        self.orders = response.asks.records.map { orderRecord -> Order in
            return Order(maker: orderRecord.order.makerAssetAmount, taker: orderRecord.order.takerAssetAmount)
          }
      }, onError: { (error) in
        Logger.e("OnError", error: error)
      }).disposed(by: disposeBag)
  }
}
