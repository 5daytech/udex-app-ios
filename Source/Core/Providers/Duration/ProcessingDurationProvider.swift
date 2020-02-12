import Foundation

class ProcessingDurationProvider: IProcessingDurationProvider {
  func getEstimatedDuration(type: ETransactionType) -> Int {
    switch type {
    case .SEND:
      return 20
    case .CONVERT:
      return 20
    case .EXCHANGE:
      return 30
    case .CANCEL:
      return 20
    case .APPROVE:
      return 20
    }
  }
  
  
}
