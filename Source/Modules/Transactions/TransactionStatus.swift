import Foundation

enum TransactionStatus {
  case PENDING
  case PROCESSING(Double)
  case COMPLETED
  
  var description: String {
    switch self {
    case .PENDING:
      return "Pending"
    case .COMPLETED:
      return "Completed"
    case .PROCESSING(let progress):
      return "Processing \(progress)"
    }
  }
}
