import RxSwift

protocol IBalanceAdapter {
    var state: AdapterState { get }
    var stateUpdatedObservable: Observable<Void> { get }
    var balance: Decimal { get }
    var balanceLocked: Decimal? { get }
    var balanceUpdatedObservable: Observable<Void> { get }
}

extension IBalanceAdapter {
    var balanceLocked: Decimal? { nil }
}
