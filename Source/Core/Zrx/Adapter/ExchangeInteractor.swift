import Foundation
import zrxkit
import RxSwift
import BigInt
import EthereumKit

class ExchangeInteractor: IExchangeInteractor {
  let coinManager: ICoinManager
  let allowanceChecker: IAllowanceChecker
  let exchangeWrapper: IZrxExchange
  let ethereumKit: EthereumKit.Kit
  let zrxKit: ZrxKit
  
  private let orderValidTime: TimeInterval = 60 * 60 * 24 * 1
  
  init(coinManager: ICoinManager, allowanceChecker: IAllowanceChecker, exchangeWrapper: IZrxExchange, ethereumKit: EthereumKit.Kit, zrxKit: ZrxKit) {
    self.coinManager = coinManager
    self.allowanceChecker = allowanceChecker
    self.exchangeWrapper = exchangeWrapper
    self.ethereumKit = ethereumKit
    self.zrxKit = zrxKit
  }
  
  func createOrder(feeRecipient: String, createData: CreateOrderData) -> Observable<SignedOrder> {
    let baseCoin = coinManager.getCoin(code: createData.coinPair.first)
    let quoteCoin = coinManager.getCoin(code: createData.coinPair.second)
    
    let baseAsset = ZrxKit.assetItemForAddress(address: baseCoin.type.address)
    let quoteAsset = ZrxKit.assetItemForAddress(address: quoteCoin.type.address)
    
    let makerAmount = BigUInt("\(createData.amount * pow(10, createData.side == .BUY ? quoteCoin.decimal : baseCoin.decimal))", radix: 10)!
    let takerAmount = BigUInt("\((createData.amount * createData.price) * pow(10, createData.side == .BUY ? baseCoin.decimal : quoteCoin.decimal))", radix: 10)!
    
    return allowanceChecker.checkAndUnlockAssetPairForPost(
      assetPair: Pair<AssetItem, AssetItem>(first: baseAsset, second: quoteAsset),
      side: createData.side
    ).flatMap { (_) -> Observable<SignedOrder> in
      self.postOrderToRelayer(
        feeRecipient: feeRecipient,
        makeAsset: baseAsset.assetData,
        makeAmount: makerAmount,
        takeAsset: quoteAsset.assetData,
        takeAmount: takerAmount,
        side: createData.side
      )
    }
  }
  
  private func postOrderToRelayer(
    feeRecipient: String,
    makeAsset: String,
    makeAmount: BigUInt,
    takeAsset: String,
    takeAmount: BigUInt,
    side: EOrderSide
  ) -> Observable<SignedOrder> {
    let expirationTime = "\(Int(Date().timeIntervalSince1970 + orderValidTime))" // Order valid for 1 day
    
    let makerAsset = side == .BUY ? takeAsset : makeAsset
    let takerAsset = side == .BUY ? makeAsset : takeAsset
    
    print("\(makeAmount)")
    print("\(takeAmount)")
    
    let order = Order(
      exchangeAddress: exchangeWrapper.contractAddress,
      makerAssetData: makerAsset,
      takerAssetData: takerAsset,
      makerAssetAmount: "\(makeAmount)",
      takerAssetAmount: "\(takeAmount)",
      makerAddress: ethereumKit.receiveAddress,
      takerAddress: "0x0000000000000000000000000000000000000000",
      expirationTimeSeconds: expirationTime,
      senderAddress: "0x0000000000000000000000000000000000000000",
      feeRecipientAddress: feeRecipient,
      makerFee: "0",
      takerFee: "0",
      salt: "\(Int(Date().timeIntervalSince1970 * 1000))"
    )
    
    let signedOrder = zrxKit.signOrder(order)
    
    if signedOrder != nil {
      return zrxKit.relayerManager.postOrder(relayerId: 0, order: signedOrder!).flatMap { (_) -> Observable<SignedOrder> in
        Observable.just(signedOrder!)
      }
    } else {
      fatalError() // Change to throw error
    }
  }
}
