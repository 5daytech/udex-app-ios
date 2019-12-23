import RxSwift

protocol ITransactionsAdapter {
    var confirmationsThreshold: Int { get }
    var lastBlockHeight: Int? { get }
    var lastBlockHeightUpdatedObservable: Observable<Void> { get }
    var transactionRecordsObservable: Observable<[TransactionRecord]> { get }
    func transactionsSingle(from: TransactionRecord?, limit: Int) -> Single<[TransactionRecord]>
}
