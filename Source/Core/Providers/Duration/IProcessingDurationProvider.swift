import Foundation

protocol IProcessingDurationProvider {
  func getEstimatedDuration(type: ETransactionType) -> Int
}
