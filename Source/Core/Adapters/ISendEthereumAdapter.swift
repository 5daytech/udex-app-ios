import RxSwift

protocol ISendEthereumAdapter {
    func availableBalance(gasPrice: Int, gasLimit: Int?) -> Decimal
    var ethereumBalance: Decimal { get }
    var minimumRequiredBalance: Decimal { get }
    var minimumSpendableAmount: Decimal? { get }
    func validate(address: String) throws
    func estimateGasLimit(to address: String, value: Decimal, gasPrice: Int?) -> Single<Int>
    func fee(gasPrice: Int, gasLimit: Int) -> Decimal
    func sendSingle(amount: Decimal, address: String, gasPrice: Int, gasLimit: Int) -> Single<Void>
}
