import EthereumKit
import RxSwift

class EthereumAdapter: EthereumBaseAdapter {
  static let decimal = 18
  
  private let feeRateProvider: IFeeRateProvider
  
  init(ethereumKit: EthereumKit.Kit, feeRateProvider: IFeeRateProvider) {
    self.feeRateProvider = feeRateProvider
    super.init(ethereumKit: ethereumKit, decimal: EthereumAdapter.decimal)
  }
  
  private func transactionRecord(fromTransaction transaction: TransactionInfo) -> TransactionRecord {
    var type: TransactionType = .sentToSelf
    var amount: Decimal = 0
    
    if let significand = Decimal(string: transaction.value) {
      amount = Decimal(sign: .plus, exponent: -decimal, significand: significand)
      
      let mineAddress = ethereumKit.receiveAddress.lowercased()
      let fromMine = transaction.from.lowercased() == mineAddress
      let toMine = transaction.to.lowercased() == mineAddress
      
      if fromMine && !toMine {
        type = .outgoing
      } else if !fromMine && toMine {
        type = .incoming
      }
    }
    
    let failed = (transaction.isError ?? 0) != 0
    
    return TransactionRecord(
      uid: transaction.hash,
      transactionHash: transaction.hash,
      transactionIndex: transaction.transactionIndex ?? 0,
      interTransactionIndex: 0,
      type: type,
      blockHeight: transaction.blockNumber,
      amount: abs(amount),
      fee: transaction.gasUsed.map { Decimal(sign: .plus, exponent: -decimal, significand: Decimal($0 * transaction.gasPrice)) },
      date: Date(timeIntervalSince1970: transaction.timestamp),
      failed: failed,
      from: transaction.from,
      to: transaction.to,
      lockInfo: nil
    )
  }
  
  override func sendSingle(to address: String, value: String, gasPrice: Int, gasLimit: Int) -> Single<String?> {
    ethereumKit.sendSingle(to: address, value: value, gasPrice: gasPrice, gasLimit: gasLimit)
      .map { txInfo in txInfo.blockHash }
      .catchError { [weak self] error in
        Single.error(self?.createSendError(from: error) ?? error)
    }
  }
  
  override func estimateGasLimit(to address: String, value: Decimal, gasPrice: Int?) -> Single<Int> {
    Single.just(ethereumKit.gasLimit)
  }
  
}

extension EthereumAdapter {
  
  static func clear(except excludedWalletIds: [String]) throws {
    try EthereumKit.Kit.clear(exceptFor: excludedWalletIds)
  }
  
}

extension EthereumAdapter: IBalanceAdapter {
  
  var state: AdapterState {
    switch ethereumKit.syncState {
    case .synced: return .synced
    case .notSynced: return .notSynced
    case .syncing: return .syncing(progress: 50, lastBlockDate: nil)
    }
  }
  
  var stateUpdatedObservable: Observable<Void> {
    ethereumKit.syncStateObservable.map { _ in () }
  }
  
  var balance: Decimal {
    balanceDecimal(balanceString: ethereumKit.balance, decimal: EthereumAdapter.decimal)
  }
  
  var balanceUpdatedObservable: Observable<Void> {
    ethereumKit.balanceObservable.map { _ in () }
  }
  
  func validate(amount: Decimal, feePriority: FeeRatePriority) -> [SendStateError] {
    var errors = [SendStateError]()
    if amount > fee(gasPrice: feeRateProvider.ethereumGasPrice(priority: feePriority), gasLimit: 0) {
      errors.append(.insufficientAmount)
    }
    return errors
  }
}

extension EthereumAdapter: ISendEthereumAdapter {
  func availableBalance(gasPrice: Int, gasLimit: Int?) -> Decimal {
    guard let gasLimit = gasLimit else {
      return balance
    }
    return max(0, balance - fee(gasPrice: gasPrice, gasLimit: gasLimit))
  }
  
  var ethereumBalance: Decimal {
    balance
  }
  
  var minimumRequiredBalance: Decimal {
    0
  }
  
  var minimumSpendableAmount: Decimal? {
    nil
  }
  
  func fee(gasPrice: Int, gasLimit: Int) -> Decimal {
    ethereumKit.fee(gasPrice: gasPrice) / pow(10, EthereumAdapter.decimal)
  }
  
  func fee(value: Decimal, address: String?, feePriority: FeeRatePriority) -> Decimal {
    ethereumKit.fee(gasPrice: feeRateProvider.ethereumGasPrice(priority: feePriority)) / pow(10, EthereumAdapter.decimal)
  }
  
  func send(amount: Decimal, address: String, feePriority: FeeRatePriority) -> Single<String?> {
    return sendSingle(amount: amount, address: address, gasPrice: feeRateProvider.ethereumGasPrice(priority: feePriority), gasLimit: ethereumKit.gasLimit)
  }
  
}

extension EthereumAdapter: ITransactionsAdapter {
  
  var coinCode: String { "ETH" }
  
  var transactionRecordsObservable: Observable<[TransactionRecord]> {
    ethereumKit.transactionsObservable.map { [weak self] in
      $0.compactMap { self?.transactionRecord(fromTransaction: $0) }
    }
  }
  
  func transactionsSingle(from: TransactionRecord?, limit: Int) -> Single<[TransactionRecord]> {
    ethereumKit.transactionsSingle(fromHash: from?.transactionHash, limit: limit)
      .map { [weak self] transactions -> [TransactionRecord] in
        transactions.compactMap { self?.transactionRecord(fromTransaction: $0) }
    }
  }
  
}
