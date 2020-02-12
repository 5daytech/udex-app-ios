import Foundation

protocol IFeeRateProvider {
  func ethereumGasPrice(priority: FeeRatePriority) -> Int
}
