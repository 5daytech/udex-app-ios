import Foundation
import FeeRateKit


class FeeRateProvider: IFeeRateProvider {
  private let lowPriority = 4_000_000_000
  private let mediumPriority = 8_000_000_000
  private let highPriority = 20_000_000_000
  private let lowPriorityDuration = 60 * 30
  private let mediumPriorityDuration = 60 * 5
  private let highPriorityDuration = 60 * 2
  
  
  func ethereumGasPrice(priority: FeeRatePriority) -> Int {
    switch priority {
    case .LOWEST:
      return lowPriority
    case .LOW:
      return (lowPriority + mediumPriority) / 2
    case .MEDIUM:
      return mediumPriority
    case .HIGH:
      return (mediumPriority + highPriority) / 2
    case .HIGHEST:
      return highPriority
    }
  }
}
