import Foundation
import zrxkit
import RxSwift
import BigInt
import EthereumKit
import Web3

class ExchangeInteractor: IExchangeInteractor {
  let coinManager: ICoinManager
  let allowanceChecker: IAllowanceChecker
  let exchangeWrapper: IZrxExchange
  let ethereumKit: EthereumKit.Kit
  let zrxKit: ZrxKit
  let appConfiguration: IAppConfigProvider
  
  private let orderValidTime: TimeInterval = 60 * 60 * 24 * 1
  
  init(appConfiguration: IAppConfigProvider, coinManager: ICoinManager, allowanceChecker: IAllowanceChecker, exchangeWrapper: IZrxExchange, ethereumKit: EthereumKit.Kit, zrxKit: ZrxKit) {
    self.appConfiguration = appConfiguration
    self.coinManager = coinManager
    self.allowanceChecker = allowanceChecker
    self.exchangeWrapper = exchangeWrapper
    self.ethereumKit = ethereumKit
    self.zrxKit = zrxKit
  }
  
  func cancelOrders(orders: [SignedOrder]) -> Observable<EthereumData> {
    return exchangeWrapper.batchCancelOrders(orders: orders, onReceipt: { (receipt) in
      
    }, onCancel: { cancelEvent in
      
    })
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
    ).flatMap { (allowed) -> Observable<SignedOrder> in
      return self.postOrderToRelayer(
        feeRecipient: feeRecipient,
        makeAsset: baseAsset.assetData,
        makeAmount: makerAmount,
        takeAsset: quoteAsset.assetData,
        takeAmount: takerAmount,
        side: createData.side
      )
    }
  }
  
  func fill(orders: [SignedOrder], fillData: FillOrderData) -> Observable<EthereumData> {
    let baseCoin = coinManager.getCoin(code: fillData.coinPair.first)
    let quoteCoin = coinManager.getCoin(code: fillData.coinPair.second)
    let amount = fillData.amount * pow(10, fillData.side == .BUY ? quoteCoin.decimal : baseCoin.decimal)
    let amountRoundedStr = String("\(amount)".split(separator: ".").first!)
    let calcAmount = BigUInt(amountRoundedStr, radix: 10)!
    return allowanceChecker.checkAndUnlockPairForFill(pair: Pair<String, String>(first: baseCoin.type.address, second: quoteCoin.type.address), side: fillData.side).flatMap { (_) -> Observable<EthereumData> in
      return self.exchangeWrapper.marketBuyOrders(orders: orders, fillAmount: calcAmount, onReceipt: { (transaction) in
        
      }) { (fillEventResponse) in
        
      }
    }
  }
  
  func ordersInfo(orders: [SignedOrder]) -> Observable<[OrderInfo]> {
    exchangeWrapper.ordersInfo(orders: orders)
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
    
    let order = Order(
      chainId: appConfiguration.zrxNetwork.id,
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
      makerFeeAssetData: "0x",
      takerFee: "0",
      takerFeeAssetData: "0x",
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
