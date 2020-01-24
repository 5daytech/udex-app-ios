import Foundation
import zrxkit
import RxSwift
import Web3
import EthereumKit

class BaseRelayerAdapter: IRelayerAdapter {
  let disposeBag = DisposeBag()
  private let relayerId: Int
  private let relayerManager: IRelayerManager
  private let relayer: Relayer
  private let coinManager: ICoinManager
  private let ethereumKit: EthereumKit.Kit
  
  private let ratesConverter: RatesConverter
  
  private var selectedPair: ExchangePair
  
  var currentPair: ExchangePair {
    selectedPair
  }
  
  let exchangeInteractor: IExchangeInteractor
  var exchangePairs: [ExchangePair] = []
  var myOrdersSubject = BehaviorSubject<[SimpleOrder]>(value: [])
  var buyOrdersSubject = BehaviorSubject<[SimpleOrder]>(value: [])
  var sellOrdersSubject = BehaviorSubject<[SimpleOrder]>(value: [])
  
  var myOrders = [OrderRecord]()
  var myOrdersInfo = [OrderInfo]()
  var buyOrders = RelayerOrdersList<OrderRecord>()
  var sellOrders = RelayerOrdersList<OrderRecord>()
  
  init(zrxkit: ZrxKit, ethereumKit: EthereumKit.Kit, coinManager: ICoinManager, ratesConverter: RatesConverter, exchangeInteractor: IExchangeInteractor, refreshInterval: Int, relayerId: Int) {
    self.ratesConverter = ratesConverter
    self.coinManager = coinManager
    self.ethereumKit = ethereumKit
    self.exchangeInteractor = exchangeInteractor
    self.relayerId = relayerId
    self.relayerManager = zrxkit.relayerManager
    self.relayer = relayerManager.availableRelayers[relayerId]
    let pair = relayerManager.availableRelayers[relayerId].availablePairs[0]
    self.selectedPair = ExchangePair(
      baseCoinCode: coinManager.getErcCoinForAddress(address: pair.first.address)!.code,
      quoteCoinCode: coinManager.getErcCoinForAddress(address: pair.second.address)!.code,
      baseAsset: pair.first,
      quoteAsset: pair.second
    )
    initPairs(relayer: relayerManager.availableRelayers[relayerId], coinManager: coinManager)
    
    let scheduler = SerialDispatchQueueScheduler(qos: .background)
    _ = Observable<Int>.interval(.microseconds(refreshInterval), scheduler: scheduler)
      .subscribe { _ in
        self.refreshOrders()
    }
    self.refreshOrders()
  }
  
  private func initPairs(relayer: Relayer, coinManager: ICoinManager) {
    exchangePairs = relayer.availablePairs
    .filter { pair -> Bool in
      let baseCoin = coinManager.getErcCoinForAddress(address: pair.first.address)
      let quoteCoin = coinManager.getErcCoinForAddress(address: pair.second.address)
      return baseCoin != nil && quoteCoin != nil
    }
    .map { pair -> ExchangePair in
      ExchangePair(
        baseCoinCode: coinManager.getErcCoinForAddress(address: pair.first.address)?.code ?? "",
        quoteCoinCode: coinManager.getErcCoinForAddress(address: pair.second.address)?.code ?? "",
        baseAsset: pair.first,
        quoteAsset: pair.second
      )
    }
  }
  
  private func refreshPair(baseAsset: String, quoteAsset: String) {
    relayerManager.getOrderbook(relayerId: relayerId, base: baseAsset, quote: quoteAsset)
      .subscribe(onNext: { (orderBookResponse) in
        let myAddress = self.ethereumKit.receiveAddress.lowercased()
        
        self.buyOrders.updatePairOrders(
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          orders: orderBookResponse.bids.records
            .filter { $0.order.makerAddress != myAddress }
            .filter { self.isFillableOrder(orderRecord: $0) }
        )
        
        self.sellOrders.updatePairOrders(
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          orders: orderBookResponse.asks.records
            .filter { $0.order.makerAddress != myAddress }
            .filter { self.isFillableOrder(orderRecord: $0) }
        )
        
        self.updateOrders()
    }).disposed(by: disposeBag)
  }
  
  private func isFillableOrder(orderRecord: OrderRecord) -> Bool {
    let remaining = BigUInt(orderRecord.metaData.remainingFillableTakerAssetAmount ?? "") ?? BigUInt.zero
    let takerAmount = BigUInt(orderRecord.order.takerAssetAmount, radix: 10) ?? BigUInt.zero
    
    if (remaining > BigUInt.zero && takerAmount > BigUInt.zero) {
      let percent = Double("\(remaining / takerAmount)") ?? 0
      return percent > 0.01
    } else {
      return false
    }
    
  }
  
  private func refreshOrders() {
    relayerManager.getOrders(relayerId: relayerId, makerAddress: ethereumKit.receiveAddress.lowercased(), limit: 100)
      .subscribe(onNext: { (orderBook) in
        self.myOrders = orderBook.records.sorted(by: { (left, right) -> Bool in
          left.order.salt > right.order.salt
        })
        
        self.myOrdersSubject.onNext(self.myOrders.compactMap { SimpleOrder.fromOrder(ratesConverter: self.ratesConverter, orderRecord: $0, side: .BUY, isMine: true) })
        
        self.exchangeInteractor.ordersInfo(orders: self.myOrders.map { $0.order })
          .subscribe(onNext: { (ordersInfo) in
            self.myOrdersInfo = ordersInfo
            self.myOrdersSubject.onNext(self.myOrders.compactMap { SimpleOrder.fromOrder(ratesConverter: self.ratesConverter, orderRecord: $0, side: .BUY, isMine: true) })
          }).disposed(by: self.disposeBag)
      }).disposed(by: disposeBag)
    
    relayer.availablePairs.forEach { (pair) in
      let base = pair.first.assetData
      let quote = pair.second.assetData
      
      self.refreshPair(baseAsset: base, quoteAsset: quote)
    }
  }
  
  func setSelected(baseCode: String, quoteCode: String) {
    selectedPair = exchangePairs.filter { $0.baseCoinCode == baseCode && $0.quoteCoinCode == quoteCode }.first!
    updateOrders()
  }
  
  private func updateOrders() {
    buyOrdersSubject.onNext(buyOrders.getPair(baseAsset: selectedPair.baseAsset.assetData, quoteAsset: selectedPair.quoteAsset.assetData).orders.compactMap { SimpleOrder.fromOrder(ratesConverter: self.ratesConverter, orderRecord: $0, side: .BUY) })
    sellOrdersSubject.onNext(sellOrders.getPair(baseAsset: selectedPair.baseAsset.assetData, quoteAsset: selectedPair.quoteAsset.assetData).orders.compactMap { SimpleOrder.fromOrder(ratesConverter: self.ratesConverter, orderRecord: $0, side: .SELL) })
  }
  
  func createOrder(createData: CreateOrderData) -> Observable<SignedOrder> {
    exchangeInteractor.createOrder(feeRecipient: relayer.feeRecipients.first!, createData: createData)
  }
  
  func fill(fillData: FillOrderData) -> Observable<EthereumData> {
    let fillResult = calculateSendAmount(coinPair: fillData.coinPair, side: fillData.side, amount: fillData.amount)
    return exchangeInteractor.fill(orders: fillResult.orders, fillData: fillData)
  }
  
  func calculateBasePrice(coinPair: Pair<String, String>, side: EOrderSide) -> Decimal {
    OrdersUtil.calculateBasePrice(orders: getPairOrders(coinPair: coinPair, side: side).orders.map { $0.order }, coinPair: coinPair, side: side)
  }
  
  func calculateFillAmount(coinPair: Pair<String, String>, side: EOrderSide, amount: Decimal) -> FillResult {
    let orders = getPairOrders(coinPair: coinPair, side: side).orders
    return calculateFillResult(orders: orders, side: side, amount: amount)
  }
  
  func calculateSendAmount(coinPair: Pair<String, String>, side: EOrderSide, amount: Decimal) -> FillResult {
    let orders = getPairOrders(coinPair: coinPair, side: side).orders
    var ordersToFill = [SignedOrder]()
    
    var requestedAmount = amount
    var fillAmount: Decimal = 0
    
    let sortedOrders = orders.compactMap { OrdersUtil.normalizeOrderDataPrice(orderRecord: $0, isSellPrice: false) }.sorted { side == .BUY ? $0.price > $1.price : $0.price < $1.price }
    
    for normalizedOrder in sortedOrders {      
      if requestedAmount != 0 {
        if requestedAmount > normalizedOrder.remainingMakerAmount {
          fillAmount += normalizedOrder.remainingTakerAmount
          requestedAmount -= normalizedOrder.remainingMakerAmount
        } else {
          fillAmount += requestedAmount * normalizedOrder.price
          requestedAmount = 0
        }
        
        if let order = normalizedOrder.order {
          ordersToFill.append(order)
        }
      } else {
        break
      }
    }
    
    return FillResult(
      orders: ordersToFill,
      receiveAmount: amount - requestedAmount,
      sendAmount: fillAmount
    )
  }
  
  private func getPairOrders(coinPair: Pair<String, String>, side: EOrderSide) -> RelayerOrders<OrderRecord> {
    let baseCoin = getErcCoin(coinCode: coinPair.first)
    let quoteCoin = getErcCoin(coinCode: coinPair.second)
    
    let baseAsset = ZrxKit.assetItemForAddress(address: baseCoin.address).assetData
    let quoteAsset = ZrxKit.assetItemForAddress(address: quoteCoin.address).assetData
    
    switch side {
    case .BUY:
      return buyOrders.getPair(baseAsset: baseAsset, quoteAsset: quoteAsset)
    default:
      return sellOrders.getPair(baseAsset: baseAsset, quoteAsset: quoteAsset)
    }
  }
  
  private func getErcCoin(coinCode: String) -> CoinType {
    coinManager.getCoin(code: coinCode).type
  }
  
  private func calculateFillResult(orders: [OrderRecord], side: EOrderSide, amount: Decimal) -> FillResult {
    var ordersToFill = [SignedOrder]()
    
    var requestedAmount = amount
    var fillAmount: Decimal = 0
    
    let sortedOrders = orders.compactMap { OrdersUtil.normalizeOrderDataPrice(orderRecord: $0) }.sorted { side == .BUY ? $0.price > $1.price : $0.price < $1.price }
    
    for orderData in sortedOrders {
      if requestedAmount != 0 {
        if requestedAmount > orderData.remainingTakerAmount {
          fillAmount += orderData.remainingMakerAmount
          requestedAmount -= orderData.remainingTakerAmount
        } else {
          fillAmount += requestedAmount * orderData.price
          requestedAmount = 0
        }
        if let order = orderData.order {
          ordersToFill.append(order)
        }
      } else {
        break
      }
    }
    
    return FillResult(orders: ordersToFill, receiveAmount: fillAmount, sendAmount: amount - requestedAmount)
  }
}
